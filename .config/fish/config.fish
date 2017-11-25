set -x TERMINAL alacritty

set -x EDITOR vim

set -x PATH /usr/local/bin $PATH

set -x PATH $HOME/.gem/ruby/2.4.0/bin $PATH
set -x PATH $HOME/.rbenv/bin $PATH
status --is-interactive; and source (rbenv init -|psub)

set -x PATH $HOME/.cargo/bin $PATH
set -x RUST_SRC_PATH $HOME/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src

alias git hub
alias l "ls -l"

function fish_prompt
  printf '%s%s%s on %s%s%s at %s%s $%s ' (set_color red) (whoami) (set_color normal) (set_color green) (hostname) (set_color normal) (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

# Print a hand rolled fortune.
fortune
echo

# Start X at login.
if status --is-login
  if test -z "$DISPLAY" -a $XDG_VTNR=1
    exec startx
  end
end
