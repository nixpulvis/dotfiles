if [ -d "$HOME/.multirust" ]
  set PATH "$HOME/.cargo/bin" $PATH
  set PATH "$HOME/.multirust/toolchains/nightly/cargo/bin" $PATH
end
