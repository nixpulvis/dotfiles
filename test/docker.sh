#!/bin/sh
# End-to-end test of the real bootstrap inside a disposable Linux container.
# Verifies the Linux gating/templating you can't exercise from macOS. The
# container is removed on exit (--rm); your machine is untouched.
#
#   test/docker.sh              # Arch (pacman)
#   test/docker.sh ubuntu       # Debian/Ubuntu (apt)
#   INSTALL=1 test/docker.sh    # also run the real package installs
#
# Without INSTALL=1 the package scripts are skipped (fast; just proves the
# dotfiles render and gate correctly on a real Linux box). Requires docker.
set -eu

REPO=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
DISTRO=${1:-arch}

case "$DISTRO" in
    arch)          IMAGE=archlinux:latest; PREP='pacman -Sy --noconfirm --needed git curl sudo' ;;
    ubuntu|debian) IMAGE=ubuntu:latest;    PREP='apt-get update && apt-get install -y git curl sudo ca-certificates' ;;
    *) echo "unknown distro: $DISTRO (use arch|ubuntu)" >&2; exit 2 ;;
esac

EXCLUDE='--exclude=scripts'
[ "${INSTALL:-0}" = "1" ] && EXCLUDE=''

docker run --rm -it -v "$REPO":/dotfiles:ro "$IMAGE" bash -c "
    set -e
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
