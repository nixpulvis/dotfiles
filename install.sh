#!/bin/sh
# Bootstrap chezmoi + these dotfiles on macOS, Linux, or WSL.
#
#   sh -c "$(curl -fsLS https://raw.githubusercontent.com/nixpulvis/dotfiles/master/install.sh)"
#
# Any extra args are passed to `chezmoi init`, e.g. to track a branch:
#   ./install.sh --branch next
set -eu

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
