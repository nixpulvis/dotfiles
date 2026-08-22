#!/bin/sh
# Bootstrap chezmoi + these dotfiles on macOS, Linux, or WSL.
#
#   sh -c "$(curl -fsLS https://raw.githubusercontent.com/nixpulvis/dotfiles/master/install.sh)"
#
# Any extra args are passed to `chezmoi init`, e.g. to track a branch:
#   ./install.sh --branch next
set -eu

# macOS: the git that `chezmoi init` clones with ships with the Xcode Command
# Line Tools, which a brand-new Mac lacks (/usr/bin/git is only a stub). Install
# them first and block until the GUI installer finishes, otherwise the clone
# below has no working git. chezmoi's builtin git isn't used here because the
# stub is in $PATH, so `useBuiltinGit = auto` still picks the broken system git.
if [ "$(uname -s)" = "Darwin" ] && ! xcode-select -p >/dev/null 2>&1; then
    echo "Installing Xcode Command Line Tools (provides git)..."
    xcode-select --install >/dev/null 2>&1 || true
    until xcode-select -p >/dev/null 2>&1; do
        sleep 5
    done
fi

if command -v chezmoi >/dev/null 2>&1; then
    chezmoi="$(command -v chezmoi)"
else
    bindir="${HOME}/.local/bin"
    echo "Installing chezmoi to ${bindir}..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "${bindir}"
    chezmoi="${bindir}/chezmoi"
fi

# init clones this repo, prompts for per-machine settings, then applies.
exec "${chezmoi}" init --apply "$@" nixpulvis
