#!/bin/zsh
# Don't be a fool.

echo "Installing .:. dotfiles"

DOTFILES=$HOME/.dotfiles

# Move dotfiles to the proper dotfiles path if they are not there already.
#TODO

# Install git post hooks.
hooks=$DOTFILES/.git/hooks
echo "#!/bin/sh
exec \$DOTFILES/install.sh" | tee $hooks/post-merge > $hooks/post-rewrite
chmod +x $hooks/post-merge $hooks/post-rewrite

# Ensure that we are work within the acceptable working directory.
if [[ $PWD != $DOTFILES ]]; then
  echo "Must be inside $DOTFILES"
  exit 1
fi

# Symlink ".link" files.
for file ($DOTFILES/**/*.link) do
  line=$(head -n 1 $file)
  eval destination=${line//(\#|\")=>/}
  ln -fs $file $destination
done
