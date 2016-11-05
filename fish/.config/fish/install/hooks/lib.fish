function dotfiles.install -d "TODO"
  echo "TRACE: dotfiles.install $argv"
  emit preinstall:package:$argv
  stow $argv
  emit postinstall:package:$argv
end

source $LIB/install/hooks/atom.fish
source $LIB/install/hooks/macos.fish
source $LIB/install/hooks/racket.fish
source $LIB/install/hooks/rust.fish
