# Setup cargo's binary path.
export PATH=$HOME/.cargo/bin:$PATH

# Set the terminal variable helps i3 decide what to do.
if type alacritty > /dev/null; then
    export TERMINAL=alacritty
elif type termite > /dev/null; then
    export TERMINAL=termite
fi

# Start a window manager if we should.
if [[ $USER != "root" ]]; then
    if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
        exec sway &> $HOME/.sway_output
    elif [[ ! $DISPLAY && $XDG_VTNR -eq 2 ]]; then
        exec startx &> $HOME/.Xoutput
    fi
fi

[[ -f ~/.bashrc ]] && . ~/.bashrc
