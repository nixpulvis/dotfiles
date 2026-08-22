#!/bin/sh
# End-to-end test of the real bootstrap inside a disposable Linux container.
# Verifies the Linux gating/templating you can't exercise from macOS. The
# container is removed on exit (--rm); your machine is untouched.
#
#   test/docker.sh              # Arch (pacman)   [emulates x86-64 on arm64 hosts]
#   test/docker.sh ubuntu       # Debian/Ubuntu (apt)   [native multi-arch]
#   INSTALL=1 test/docker.sh    # also run the real package installs
#   PLATFORM=linux/amd64 ...    # force a platform (needs qemu/binfmt)
#
# Without INSTALL=1 the package scripts are skipped (fast; just proves the
# dotfiles render and gate correctly on a real Linux box). Requires docker.
set -eu

REPO=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
DISTRO=${1:-arch}

# Arch publishes no arm64 image, so emulate x86-64 there; Ubuntu is multi-arch.
case "$DISTRO" in
    arch)          IMAGE=archlinux:latest; PLAT=${PLATFORM:-linux/amd64}; PREP='pacman -Sy --noconfirm --needed git curl sudo'; ARCH=1 ;;
    ubuntu|debian) IMAGE=ubuntu:latest;    PLAT=${PLATFORM:-};           PREP='apt-get update && apt-get install -y git curl sudo ca-certificates'; ARCH=0 ;;
    *) echo "unknown distro: $DISTRO (use arch|ubuntu)" >&2; exit 2 ;;
esac

PLATARG=''
if [ -n "$PLAT" ]; then
    PLATARG="--platform=$PLAT"
    [ "$PLAT" = "linux/amd64" ] && [ "$(uname -m)" = "arm64" ] && \
        echo "note: emulating $PLAT on arm64 (slow; needs qemu/binfmt)." >&2
fi

EXCLUDE='--exclude=scripts'
[ "${INSTALL:-0}" = "1" ] && EXCLUDE=''

# pacman 7's download sandbox (alpm user + seccomp filter) can't initialize
# under qemu emulation, so disable it in the container and relax Docker's
# seccomp for the emulated run. Real (native) Arch machines are unaffected.
SECARG=''
PACFIX=':'
if [ "$ARCH" = "1" ]; then
    SECARG='--security-opt seccomp=unconfined'
    PACFIX="sed -i '/^\\[options\\]/a DisableSandbox' /etc/pacman.conf"
fi

docker run --rm -it $PLATARG $SECARG -v "$REPO":/dotfiles:ro "$IMAGE" bash -c "
    set -e
    $PACFIX
    $PREP
    useradd -m -s /bin/bash tester
    echo 'tester ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/tester
    su - tester -c '
        git config --global --add safe.directory /dotfiles
        sh -c \"\$(curl -fsLS get.chezmoi.io)\" -- -b \$HOME/.local/bin >/dev/null
        CM=\$HOME/.local/bin/chezmoi
        \$CM init --apply --source /dotfiles --promptDefaults $EXCLUDE
        echo; echo \"=== managed ===\"; \$CM --source /dotfiles managed
        echo; echo \"=== ~ tree ===\"; find \$HOME -maxdepth 3 -not -path \"*/.local/*\" | sort
    '
"
