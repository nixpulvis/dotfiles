#!/bin/sh
# End-to-end test of the real bootstrap inside a throwaway Linux container, for
# the Linux gating, templating and systemd user services you can't exercise
# from macOS. The container boots systemd and the test user gets a user manager,
# as on a real login. It's removed on exit, so your machine isn't touched.
#
#   test/docker.sh              # Debian/Ubuntu (apt)   [native multi-arch]
#   test/docker.sh arch         # Arch (pacman)   [x86-64 docker hosts only, e.g. CI]
#   INSTALL=1 test/docker.sh    # also run the real package installs
#   PLATFORM=linux/amd64 ...    # force a platform (needs qemu/binfmt)
#
# Without INSTALL=1 chezmoi skips its scripts, and only the run_onchange_ setup
# scripts are run by hand afterwards, so the package and omp installs are
# skipped. That's fast and proves the dotfiles render, gate and start their
# services on a real Linux box.
# Requires docker. The container is --privileged so systemd can run in it.
set -eu

REPO=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
DISTRO=${1:-ubuntu}

# Arch publishes x86-64 images only, and its systemd (261 as of writing) can't
# boot emulated on arm64: it exits at startup ("Failed to pin executor
# binary") because neither Rosetta nor colima's qemu 7.0 implements the
# faccessat2 syscall it needs. So Arch runs on x86-64 docker hosts, i.e. CI.
# Ubuntu's tzdata asks for a region and city on install. Pointing /etc/localtime
# at $TZ first and installing noninteractively skips both prompts. Its image
# also lacks systemd, libpam-systemd (which user@.service needs to set up the
# user manager) and procps (for the checks), all of which Arch's includes.
case "$DISTRO" in
    arch)
        host=$(docker info --format '{{.Architecture}}')
        if [ "$host" != x86_64 ]; then
            echo "arch: needs an x86-64 docker host, not $host; it runs in CI. Use 'test/docker.sh ubuntu' here." >&2
            exit 2
        fi
        IMAGE=archlinux:latest; PREP='pacman -Sy --noconfirm --needed git curl sudo openssh' ;;
    ubuntu|debian)
        IMAGE=ubuntu:latest; PREP='ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y git curl sudo ca-certificates openssh-client procps systemd libpam-systemd' ;;
    *) echo "unknown distro: $DISTRO (use ubuntu|arch)" >&2; exit 2 ;;
esac

PLATARG=''
if [ -n "${PLATFORM:-}" ]; then
    PLATARG="--platform=$PLATFORM"
    [ "$PLATFORM" = "linux/amd64" ] && [ "$(uname -m)" = "arm64" ] && \
        echo "note: emulating $PLATFORM on arm64 (slow; needs qemu/binfmt)." >&2
fi

EXCLUDE='--exclude=scripts'
[ "${INSTALL:-0}" = "1" ] && EXCLUDE=''

C=dotfiles-test-$$
trap 'docker rm -f "$C" >/dev/null 2>&1 || true' EXIT INT TERM

# Install the prerequisites, then replace the shell with systemd as PID 1.
echo "=== preparing $IMAGE and booting systemd (docker logs -f $C to follow) ==="
docker run -d --name "$C" --privileged --cgroupns=private --tmpfs /run --tmpfs /run/lock \
    -e TZ=America/New_York $PLATARG -v "$REPO":/dotfiles:ro "$IMAGE" bash -c "
    set -e
    $PREP
    exec /usr/lib/systemd/systemd
" >/dev/null

# Until PREP finishes, PID 1 is still bash and systemctl fails or says
# "offline". "degraded" is fine: some system units fail inside containers.
tries=0
until state=$(docker exec "$C" systemctl is-system-running 2>/dev/null); [ "$state" = running ] || [ "$state" = degraded ]; do
    if [ "$(docker inspect -f '{{.State.Running}}' "$C" 2>/dev/null)" != true ]; then
        docker logs "$C" >&2 || true
        echo "container exited before systemd booted" >&2
        exit 1
    fi
    tries=$((tries + 1))
    if [ "$tries" -ge 900 ]; then
        docker logs "$C" >&2 || true
        echo "systemd didn't finish booting (state: ${state:-none})" >&2
        exit 1
    fi
    sleep 1
done

# The test user, and its systemd user manager, which a login would start.
docker exec -i "$C" bash -s <<'EOF'
set -e
useradd -m -s /bin/bash tester
echo 'tester ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/tester
systemctl start "user@$(id -u tester).service"
EOF
TUID=$(docker exec "$C" id -u tester)

docker exec -i -u tester -w /home/tester \
    -e HOME=/home/tester -e XDG_RUNTIME_DIR="/run/user/$TUID" -e EXCLUDE="$EXCLUDE" \
    "$C" bash -s <<'EOF'
set -eu
git config --global --add safe.directory /dotfiles
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin" >/dev/null
CM=$HOME/.local/bin/chezmoi
$CM init --apply --source /dotfiles --promptDefaults $EXCLUDE

# run_onchange_ scripts are setup, not installs, so run them even when chezmoi
# skipped its scripts. Each renders empty where it doesn't apply.
if [ -n "$EXCLUDE" ]; then
    for script in /dotfiles/home/run_onchange_*.sh.tmpl; do
        $CM --source /dotfiles execute-template < "$script" | sh
    done
fi

echo; echo "=== managed ==="; $CM --source /dotfiles managed
echo; echo "=== ~ tree ==="; find "$HOME" -maxdepth 3 -not -path "*/.local/*" | sort

# One agent from the user service, used by every shell, and shells don't start
# their own (one started from a shell outlives it).
echo; echo "=== ssh-agent ==="
systemctl --user is-active ssh-agent.service
for _ in 1 2 3; do bash -lic true >/dev/null 2>&1; done
sock=$(bash -lc 'printf %s "${SSH_AUTH_SOCK-}"')
if [ "$sock" != "$XDG_RUNTIME_DIR/ssh-agent.socket" ]; then
    echo "SSH_AUTH_SOCK is '$sock', not the user service's socket" >&2
    exit 1
fi
rc=0
SSH_AUTH_SOCK=$sock ssh-add -l >/dev/null 2>&1 || rc=$?
if [ "$rc" -ne 1 ]; then
    echo "ssh-add -l exited $rc; expected 1 (agent reachable, no keys)" >&2
    exit 1
fi
agents=$(pgrep -c -u tester -x ssh-agent || true)
if [ "$agents" -ne 1 ]; then
    echo "$agents ssh-agent processes after starting shells; expected 1" >&2
    pgrep -a -u tester -x ssh-agent >&2 || true
    exit 1
fi
echo "ok: $sock, 1 agent"
EOF
