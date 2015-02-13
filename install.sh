#!/bin/sh
# Don't be a fool.

echo ".:. Installing dotfiles... "

DOTFILES=$HOME/.dotfiles

# Ensure that we are work within the acceptable working directory.
if [ $PWD != $DOTFILES ]; then
  echo "Must be inside $DOTFILES"
  exit 1
fi

# Symlink ".link" files.
for file in $DOTFILES/**/*.link; do
  destination=$(head -n 1 $file | sed "s/[\!|#|\"|;|//]*=>//")
  echo ".:. $file -> $destination"
  eval mkdir -p `dirname $destination`
  eval ln -fs $file $destination
done

echo ".:. Please run \"exec $SHELL\" in current shells."
