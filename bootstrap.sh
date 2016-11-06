#!/bin/bash
if ! type "fish" 2&> /dev/null; then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" </dev/null
  echo "hit1"
  brew install fish
fi
echo
echo "Now run \`fish\` to get started. Within fish \`dotfiles.install\` will \
install the complete system."
