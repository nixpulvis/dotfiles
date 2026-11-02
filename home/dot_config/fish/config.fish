# We edit with Neovim.
set -x EDITOR nvim
set -x VISUAL nvim

# Executables in our home directory.
set -x PATH $HOME/.bin $PATH

# Scripts from the nixpulvis.com repo (e.g. scribe), on machines that have it.
# The code directory is ~/Code on some machines and ~/code on others; the first
# match wins (they're the same directory on case-insensitive macOS).
for dir in $HOME/Code $HOME/code
    if test -d $dir/nixpulvis.com/bin
        set -x PATH $dir/nixpulvis.com/bin $PATH
        break
    end
end

# Some of our own custom stuff might end up here.
set -x PATH /usr/local/bin $PATH

# Setup rbenv.
set -x PATH $HOME/.rbenv/bin $PATH
if type -q rbenv
    source (rbenv init -|psub)
end

set -x PIPX_HOME $HOME/.local/pipx

if type -q ssh-agent; and not set -q SSH_AUTH_SOCK
    eval (ssh-agent -c) &>/dev/null
end

# Setup rust src (resolved from the active toolchain).
if type -q rustc
    set -x RUST_SRC_PATH (rustc --print sysroot)/lib/rustlib/src/rust/library
end

# List with eza where it's installed. Its sizes are human-readable by default
# and -a skips . and .., matching ls -h and -A. Without eza, l stays ls -l and
# ll/la fall back to fish's built-in ls versions. --git adds a per-file status
# column inside repos; long-iso dates are YYYY-MM-DD HH:MM. -g --smart-group
# shows the group only when it isn't the owner's name. --classify needs =auto
# spelled out, since a bare -F would take the first path argument as its value.
# lt/lat are l/la as a tree; ls has no tree view, so they only exist with eza.
if type -q eza
    set -l eza_long eza -l --git --time-style=long-iso -g --smart-group --classify=auto
    alias l "$eza_long"
    alias ll "$eza_long"
    alias la "$eza_long -a"
    alias lt "$eza_long --tree"
    alias lat "$eza_long -a --tree"
else
    alias l "ls -l"
end

if type -q setxkbmap; and [ "$XDG_SESSION_TYPE" = "tty" ]
    # Remap caps lock to escape.
    setxkbmap -option caps:escape
end
# See also .config/sway/config input "type:keyboard".

# Fish git config.
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showcolorhints

# Autosuggestions default to brblack, which our Alacritty theme renders as
# #0C0C0C (invisible on the #161616 background). Use a readable gray instead.
set -g fish_color_autosuggestion 666666

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
    printf '%s%s%s' (set_color -d white) (date '+%Y-%m-%d %T%z') (set_color normal)
end

# Print a nice startup message.
function fish_greeting
  if type -q fortune
      fortune
  end
  echo "><_> tick... tock..."
end

