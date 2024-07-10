#! /bin/bash

if [[ "$(playerctl -p spotify status)" = "Playing"  ]]; then
    # hyprctl dispatch -- exec "[float; size 400 200; move 765 680; noborder; noshadow; rounding 0] SDL_VIDEODRIVER=wayland SDL_VIDEO_ALLOW_SCREENSAVER=1 glava" 
    hyprlock --config ~/.config/hyprlock/music.conf
    # pkill glava
    # Function to launch cava with hyprctl dispatch
else :
    hyprlock 
fi 

