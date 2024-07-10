#! /bin/bash

if [[ "$(playerctl -p spotify status)" = "Playing"  ]]; then
    hyprlock --config ~/.config/hyprlock/music.conf

else :
    hyprlock 
fi 

