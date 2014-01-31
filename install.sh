#!/bin/zsh
# Don't be a fool.

echo -n ".:. Installing dotfiles... "

DOTFILES=$HOME/.dotfiles

# Ensure that we are work within the acceptable working directory.
if [[ $PWD != $DOTFILES ]]; then
  echo "Must be inside $DOTFILES"
  exit 1
fi

# Make needed directories.
mkdir -p $HOME/.vim/colors

# Symlink ".link" files.
for file ($DOTFILES/**/*.link) do
  line=$(head -n 1 $file)
  eval destination=${line//(\#|\"|\/\/)=>/}
  ln -fs $file $destination
done

echo "done"
echo ".:. Please run \"exec \$SHELL\" in current shells."
