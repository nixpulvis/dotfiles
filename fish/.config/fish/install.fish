# You install packages.
function dotfiles.install -d "TODO"
  echo "TRACE: dotfiles.install $argv"
  emit preinstall:package:$argv
  stow $argv
  emit postinstall:package:$argv
end

source $LIB/hooks/lib.fish
