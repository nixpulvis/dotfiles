#!/bin/sh

if [[ ! `command -v git` ]]; then
  echo "git not found, installing..."

  # Make this platform independent.
  apt-get install git
fi

# Get the dotfiles.
echo "Getting latest dotfiles from git."
DOTFILES=~/.dotfiles
if [[ -d "$DOTFILES" ]]; then
  cd "$DOTFILES"
  git pull
else
  git clone git://github.com/nathan/dotfiles.git "$DOTFILES"
  cd "$DOTFILES"
fi

# Make sure we have ruby (1.8.7 or greater)
if [[ ! `command -v ruby` ]]; then
  echo "ruby not found, installing..."

  # Make this platform independent.
  apt-get install ruby
fi

# Set them up.
# ruby "$DOTFILES"/integrate.rb