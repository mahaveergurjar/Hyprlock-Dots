if [[ "$(playerctl -p spotify status 2>/dev/null)" = "Playing" ]]; then
    # Kill any existing Glava instances
    pkill glava

    # Launch Glava in full-screen mode
    glava --desktop &
    sleep 0.2  # Ensure Glava initializes properly

    # Get the Glava window ID
    GLAVA_WIN=$(xdotool search --onlyvisible --class "glava" | head -n 1)

    # Make Glava fullscreen
    if [[ -n "$GLAVA_WIN" ]]; then
        hyprctl dispatch fullscreen "$GLAVA_WIN" 1
    fi

    # Lock screen with music theme
    hyprlock --config ~/.config/hyprlock/music.conf

else
    # If music is not playing, just lock normally
    hyprlock
fi

sleep 0.1 
pkill glava
