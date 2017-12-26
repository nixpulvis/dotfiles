# Set the terminal variable helps i3 decide what to do.
if type -q alacritty
    set -x TERMINAL alacritty
else if type -q termite
    set -x TERMINAL termite
end

# We edit files with Vim.
set -x EDITOR vim

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
    printf '%s%s' (set_color -d white) (date)
end

# Start X at login.
if status --is-login; and test -z "$DISPLAY"; \
                      and test -n "$XDG_VTNR"; \
                      and test "$XDG_VTNR" -eq 1
    exec startx > ~/.Xoutput 2>&1
else
    # Print a hand rolled fortune.
    fortune
    echo
end

