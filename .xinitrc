#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# Merge in defaults and keymaps.
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi
if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi
if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi
if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# Start installed xinit hook scripts.
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Start xautolock: TODO: systemd unit.
exec xautolock -time 3 -locker $HOME/.config/i3/lock &

# XXX: This is computer spesific, and shouldn't be committed. It would be nice
# to be able to persist this another way though.
xrandr --output DP-1-3 --primary
xrandr --dpi 128
xrandr --output DP-1-1 --rotate left
xrandr --output DP-1-1 --right-of DP-1-3
xrandr --output eDP-1 --left-of DP-1-3

# Start our window manager.
exec i3

