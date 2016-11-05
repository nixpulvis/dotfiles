# Wishlist:
# - `suppress` hides lines of stdout that match a regex.
# - `run` wraps a system call into a read call to a unix pipe, that only prints
#   on error, or in grey in verbose mode.


# TODO: Revisit in fish.
# # If we are a login shell start the WM.
# if test (uname) = Linux
#   if status --is-login
#     if test -z "$DISPLAY" -a "$XDG_VTNR = 1"
#       exec startx
#     end
#   end
# end

set -x DOTFILES $HOME/.dotfiles
set -x LIB      $DOTFILES/fish/.config/fish

source $LIB/alias.fish
source $LIB/greeting.fish
source $LIB/install/lib.fish
source $LIB/paths.fish
source $LIB/prompt.fish
