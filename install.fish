#!/usr/bin/env fish

# Ensure we're in a good state with git.
git submodule update --recursive --remote

# TODO: copy SSH identity from flashdrive.
# ```bash
# cp -r /Volumes/BLACKSNOW/.ssh ~/.ssh
# ```

# TODO: https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/#adding-your-ssh-key-to-the-ssh-agent

# TODO: Update computer name

# Install some packages.
stow fish bin git

# OS specific installation.
switch (uname)
case Linux
  stow linux
  source $HOME/.config/install.fish
case Darwin
  stow macos
  source $HOME/.config/install.fish
end

# Install the atom package.
stow atom
source $HOME/.atom/install.fish

stow racket
source $HOME/.config/racket/install.fish

stow ruby

# Finally, change the shell.
if not grep fish /etc/shells >/dev/null
  echo 'Adding `/usr/local/bin/fish` to /etc/shells.'
  sudo sh -c 'echo "/usr/local/bin/fish" >> /etc/shells'
end
if [ $SHELL != '/usr/local/bin/fish' ]
  echo 'Changing the user shell to /usr/local/bin/fish.'
  chsh -s /usr/local/bin/fish
end

echo 'Done!'
