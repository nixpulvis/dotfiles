# Set the terminal variable helps i3 decide what to do.
if type /home/nixpulvis/.cargo/bin/alacritty > /dev/null; then
    export TERMINAL=/home/nixpulvis/.cargo/bin/alacritty
elif type termite > /dev/null; then
    export TERMINAL=termite
fi

# Start X if we should.
# TODO: root?
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
	exec startx &> $HOME/.Xoutput
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc

