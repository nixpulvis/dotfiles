#!/usr/bin/env fish
source $HOME/.dotfiles/fish/.config/fish/install.fish

# First we update the dotfiles with git. Staying up to date with the public
# version of the code is important to me.
git pull
git submodule init
git submodule update --recursive --remote

# Install the packages and run thier pre and post install hooks. The order here
# matters quite a lot, and can be tricky.
install.arch
install.package atom
install.package fish
install.package bin
install.package git
install.package racket
install.package ruby
install.shell
