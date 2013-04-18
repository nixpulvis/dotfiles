#!/bin/zsh
# Don't be a fool.

echo "Installing .:. dotfiles"

dotfiles=$HOME/.dotfiles

# Move dotfiles to the proper dotfiles path if they are not there already.
#TODO

# Ensure that we are work within the acceptable working directory.
if [[ $PWD != $dotfiles ]]; then
  echo "Must be inside $dotfiles"
  exit 1
fi

# Symlink ".link" files.
for file ($dotfiles/**/*.link) do
  line=$(head -n 1 $file)
  eval destination=${line//(\#|\")=>/}
  ln -fs $file $destination
done
