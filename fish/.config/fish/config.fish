source $HOME/.config/fish/aliases.fish
source $HOME/.config/fish/greeting.fish
source $HOME/.config/fish/paths.fish
source $HOME/.config/fish/prompt.fish

# TODO: Revisit in fish.
# # If we are a login shell start the WM.
# if test (uname) = Linux
#   if status --is-login
#     if test -z "$DISPLAY" -a "$XDG_VTNR = 1"
#       exec startx
#     end
#   end
# end