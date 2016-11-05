function _add_to_path --description 'Persistently prepends paths to your PATH'
  set --universal fish_user_paths $fish_user_paths $argv
end

_add_to_path $HOME/.bin
_add_to_path $HOME/.cargo/bin
