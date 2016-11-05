function dotfiles.install.package -d "TODO"
  echo "TRACE: dotfiles.install.package $argv"
  emit preinstall:package:$argv
  stow $argv
  emit postinstall:package:$argv
end

source $LIB/install/package/atom.fish
source $LIB/install/package/macos.fish
source $LIB/install/package/racket.fish
source $LIB/install/package/rust.fish
