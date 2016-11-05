function _postinstall.package.fonts -e postinstall:package:fonts
  # Install fonts.
  cp $HOME/.dotfiles/fonts/*.ttf /Library/Fonts/
end
