#!/bin/sh
# Don't be a fool.

echo -n ".:. Installing dotfiles... "

DOTFILES=$HOME/.dotfiles

# Ensure that we are work within the acceptable working directory.
if [ $PWD != $DOTFILES ]; then
  echo "Must be inside $DOTFILES"
  exit 1
fi

# Symlink ".link" files.
for file in $DOTFILES/**/*.link; do
  destination=$(head -n 1 $file | sed "s/[#|\"|;|//]*=>//")
  echo "Linking $file to $destination"
  mkdir -p `dirname $destination`
  ln -fs $file $destination
done

echo ".:. Please run \"exec fish\" in current shells."
