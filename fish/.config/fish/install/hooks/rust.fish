function __ -e postinstall.package:racket -d "Install rustup for managing the Rust life."
  curl https://sh.rustup.rs -sSf | sh
end
