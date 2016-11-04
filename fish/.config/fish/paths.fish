# ~/.config/fish/functions/add_to_path.fish
function add_to_path --description 'Persistently prepends paths to your PATH'
  set --universal fish_user_paths $fish_user_paths $argv
end

add_to_path $HOME/.bin
add_to_path $HOME/.cargo/bin
