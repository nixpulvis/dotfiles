# Homebrew
##########

# Install fonts.
cp $HOME/.dotfiles/.3rd/Fira/ttf/*.ttf /Library/Fonts/

# Install homebrew (without prompt).
/usr/bin/ruby -e (curl -fsSL "https://raw.githubusercontent.com/Homebrew/install/master/install") </dev/null

# Install Homebrew bundle.
brew bundle --global

# Install the One Dark terminal theme.
# TODO: Automate this?
echo "TODO: Open the following theme and make it (One Dark) the default."
echo "`open $HOME/.dotfiles/.3rd/atom-one-dark-terminal/scheme/terminal/One\ Dark.terminal`"
echo "TODO: Set the font to Fira Mono 14px."

# UX
####

# TODO: Turn off all options in Keyboard/Text.
# TODO: High contrast.
