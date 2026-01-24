#!/usr/bin/env bash

if [[ "$(playerctl -p spotify status 2>/dev/null)" == "Playing" ]]; then
    pkill glava

    # Start Glava (NOT desktop mode)
    glava &
    sleep 0.6

    # Focus Glava window
    hyprctl dispatch focuswindow class:glava
    sleep 0.1

    # Fullscreen focused window
    hyprctl dispatch fullscreen 

    # Lock screen
    hyprlock --config ~/.config/hyprlock/music.conf
else
    hyprlock
fi

pkill glava
