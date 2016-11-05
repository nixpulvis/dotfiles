# Wishlist:
# - `suppress` hides lines of stdout that match a regex.
# - `run` wraps a system call into a read call to a unix pipe, that only prints
#   on error, or in grey in verbose mode.

function install.name -d "Set the name of this computer."
  # TODO: Update computer name
end

function install.shell -d "Set the default shell."
  if not grep fish /etc/shells >/dev/null
    echo 'Adding `/usr/local/bin/fish` to /etc/shells.'
    sudo sh -c 'echo "/usr/local/bin/fish" >> /etc/shells'
  end
  if [ $SHELL != '/usr/local/bin/fish' ]
    echo 'Changing the user shell to /usr/local/bin/fish.'
    chsh -s /usr/local/bin/fish
  end
end

function install.ssh -d "Install the SSH identity from flash media."
  # TODO: copy SSH identity from flashdrive.
  # ```bash
  # cp -r /Volumes/BLACKSNOW/.ssh ~/.ssh
  # ```
  # TODO: https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/#adding-your-ssh-key-to-the-ssh-agent
end

function install.arch
  switch (uname)
  case Darwin
    install.package macos
  case Linux
    install.package linux
  end
end

function install.rust -d "Install rustup for managing the Rust life."
  curl https://sh.rustup.rs -sSf | sh
end

function install.package
  echo "TRACE: install.package($argv)"
  emit preinstall:package:$argv
  stow $argv
  emit postinstall:package:$argv
end

function _preinstall.package.macos -e preinstall:package:macos
  # Install fonts.
  cp $HOME/.dotfiles/fonts/*.ttf /Library/Fonts/

  # Install homebrew (without prompt).
  /usr/bin/ruby -e (curl -fsSL "https://raw.githubusercontent.com/Homebrew/install/master/install") </dev/null

  # We need stow first and foremost.
  brew install stow
end

function _postinstall.package.macos -e postinstall:package:macos
  # Install Homebrew bundle.
  brew bundle --global

  # Start all the installed services.
  brew services start --all

  # UX
  ####

  # TODO: Turn off all options in Keyboard/Text.
  # TODO: High contrast.
  # TODO: Disable autocomplete and the like.
end

function _preinstall.package.atom -e preinstall:package:atom
  rm -rf ~/.atom
end

function _postinstall.package.atom -e postinstall:package:atom
  if [ "$SKIP_APM_STARS_INSTALL" != "1" ]
    pip install jupyter
    apm stars --install
  end
end

function _postinstall.package.racket -e postinstall.package:racket
  # FIXME: This is currently throwing an error, but still works.
  raco pkg install --batch --deps search-auto xrepl
end
