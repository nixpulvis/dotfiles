function dotfiles.install.pre.macos
  # Install homebrew (without prompt).
  /usr/bin/ruby -e (curl -fsSL "https://raw.githubusercontent.com/Homebrew/install/master/install") </dev/null

  # We need stow first and foremost.
  brew install stow
end

function dotfiles.install.post.macos
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
