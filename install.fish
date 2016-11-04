#!/usr/bin/env fish

# Ensure we're in a good state with git.
git submodule init
git submodule update --recursive --remote

# TODO: copy SSH identity from flashdrive.
# ```bash
# cp -r /Volumes/BLACKSNOW/.ssh ~/.ssh
# ```

# TODO: https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/#adding-your-ssh-key-to-the-ssh-agent

# TODO: Update computer name

# OS specific installation.
switch (uname)
case Linux
  stow linux
case Darwin
  # Homebrew
  ##########

  # Install fonts.
  cp $HOME/.dotfiles/fonts/*.ttf /Library/Fonts/

  # Install homebrew (without prompt).
  /usr/bin/ruby -e (curl -fsSL "https://raw.githubusercontent.com/Homebrew/install/master/install") </dev/null

  # We need stow first and foremost.
  brew install stow

  # Put macos files in place.
  stow macos

  # Install Homebrew bundle.
  brew bundle --global

  # Start all the installed services.
  brew services start --all

  # UX
  ####

  # TODO: Turn off all options in Keyboard/Text.
  # TODO: High contrast.
end

# Install some packages.
stow fish bin git

# Atom
######

rm -rf ~/.atom
stow atom
if [ "$SKIP_APM_STARS_INSTALL" != "1" ]
  pip install jupyter
  apm stars --install
end

# Racket
########

stow racket
# FIXME: This is currently throwing an error, but still works.
raco pkg install --batch --deps search-auto xrepl

# Ruby
######

stow ruby

# Rust
######

curl https://sh.rustup.rs -sSf | sh

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
