#!/bin/bash

xrandr --dpi 128

if [ "$1" = "single" ]; then
    xrandr --auto
    xrandr --output DP-1-1 --off
    xrandr --output DP-1-3 --primary
    xrandr --output eDP-1 --off
elif [ "$1" = "solo" ]; then
    xrandr --auto
    xrandr --output DP-1-1 --off
    xrandr --output DP-1-3 --off
    xrandr --output eDP-1 --primary
else
    xrandr --auto
    xrandr --output DP-1-1 --right-of DP-1-3 --rotate left
    xrandr --output DP-1-3 --primary
    xrandr --output eDP-1 --left-of DP-1-3
fi
