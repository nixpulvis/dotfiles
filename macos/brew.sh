if ! hash brew 2>/dev/null; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Tap some other brews.
brew tap caskroom/fonts

# Install brews.
brew install fish
brew install wget
brew install fortune
brew install ack

# Install casks, see https://caskroom.github.io.
brew cask install atom
brew cask install spectacle
brew cask install font-fira-code
