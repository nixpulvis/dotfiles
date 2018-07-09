# We edit files with Vim.
set -x EDITOR vim

# Executables in our home directory.
set -x PATH $HOME/.bin $PATH

# Some of our own custom stuff might end up here.
set -x PATH /usr/local/bin $PATH

# Setup rbenv.
set -x PATH $HOME/.rbenv/bin $PATH
if type -q rbenv
    source (rbenv init -|psub)
end

# Setup cargo and rust.
set -x PATH $HOME/.cargo/bin $PATH
set -x RUST_SRC_PATH $HOME/.rustup/toolchains/nightly-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src

alias git hub
alias l "ls -l"

# Remap caps lock to escape.
setxkbmap -option caps:escape

# Fish git config.
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showcolorhints

function fish_prompt
  printf '%s%s%s@%s%s%s:%s%s%s%s $ ' \
  (set_color red) (whoami) (set_color normal) \
  (set_color blue) (hostname) (set_color normal) \
  (set_color green) (prompt_pwd) (set_color normal) \
  (__fish_git_prompt)
end

function fish_right_prompt
    set last_status $status
    if test $last_status -ne 0
        echo -n '('(set_color red)$last_status(set_color normal)') '
    end
    printf '%s%s%s' (set_color -d white) (date '+%D %T %Z') (set_color normal)
end

# Print a nice startup message.
function fish_greeting
  fortune
  echo "><_> tick... tock..."
end

source ~/.asdf/asdf.fish
