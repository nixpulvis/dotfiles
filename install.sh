#!/bin/bash
if ! type "fish" 2&> /dev/null; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null
  brew install fish
fi
export LIB=fish/.config/fish
exec fish -c "source $LIB/install.fish" -c "dotfiles.install"
