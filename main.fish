#!/usr/bin/env fish

# Locally source the fish config because we're bootstrapping fish.
source $HOME/.dotfiles/fish/.config/fish/config.fish

# First we update the dotfiles with git. Staying up to date with the public
# version of the code is important to me.
git pull
git submodule init
git submodule update --recursive --remote

# Install the packages and run thier pre and post install hooks. The order here
# matters quite a lot, and can be tricky.
switch (uname)
case Darwin
  dotfiles.install macos
case Linux
  dotfiles.install linux
end
# TODO: Make a package as well, allowing install package to be simply install.
dotfiles.install.system
dotfiles.install atom
dotfiles.install fish
dotfiles.install bin
dotfiles.install git
dotfiles.install racket
dotfiles.install ruby
