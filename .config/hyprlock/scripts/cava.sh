#!/bin/bash
#
# Vertical Equalizer Visualizer (Dense Vertical Layout)
# -----------------------------------------------------
# This script generates a multi-row visualizer effect by outputting stacked lines
# of Pango-formatted characters. The animation is driven by the system clock
# to ensure smooth motion, and it only runs when music is playing (via playerctl).
#

player="spotify"
VIS_BARS=48             # Width (number of columns) - Increased for full width
MAX_HEIGHT=9            # Height (number of levels)
COLOR_ACTIVE="#FFD97A"  # Yellow/Gold for active peak
COLOR_DIM="#c3b389ff"   # COMPLETELY TRANSPARENT
SPACE_CHAR=" "          # Character for spacing between columns

# Function to find the currently playing player
find_player() {
    local status
    status=$(playerctl -p "$player" status 2>/dev/null)
    if [[ "$status" == "Playing" || "$status" == "Paused" ]]; then
        echo "$player"
        return
    fi
    playerctl -l 2>/dev/null | head -n 1
}

generate_visualizer() {
    local current_player
    current_player=$(find_player)
    [[ -z "$current_player" ]] && exit 0

    local status
    status=$(playerctl -p "$current_player" status 2>/dev/null)
    [[ "$status" != "Playing" ]] && exit 0

    # Use high-res system time (milliseconds) for smooth, non-stuck animation
    local CURRENT_TIME_MS
    CURRENT_TIME_MS=$(date +%s%3N | cut -c-13)
    
    # MASTER_PHASE controls the speed of the wave motion (Lower divisor = faster)
    local MASTER_PHASE=$(( CURRENT_TIME_MS / 90 ))

    local heights=()
    # Calculate height for each bar using an increased factor (31) to prevent short horizontal repetition
    for ((i=0; i<VIS_BARS; i++)); do
        # We use '31' to break the spatial repetition across the 48 bars.
        # The result is clamped by modulus (MAX_HEIGHT * 2 = 18).
        local h=$(( ( (i * 31 + MASTER_PHASE) % (MAX_HEIGHT * 2) ) ))
        
        # Triangle wave clamp: Fold the values back down after MAX_HEIGHT is reached
        if (( h > MAX_HEIGHT )); then
            h=$(( MAX_HEIGHT * 2 - h ))
        fi
        
        # Ensure minimum height is 1 when music is playing (prevents visual dropout)
        if (( h < 1 )); then
            h=1
        fi
        
        heights[i]=$h
    done

    # Draw stacked bars row by row (from top to bottom)
    for ((row=MAX_HEIGHT; row>0; row--)); do
        local line=""
        for ((i=0; i<VIS_BARS; i++)); do
            # Check if the calculated height for this bar is greater than or equal to the current row number
            if (( heights[i] >= row )); then
                # Bar is active at this row level (use active color)
                line+="<span foreground=\"$COLOR_ACTIVE\">█</span>"
            else
                # Bar is below this row level (use dim background color)
                line+="<span foreground=\"$COLOR_DIM\">█</span>"
            fi
            # Add a small space to create separation between columns (adjust this spacing for visual preference)
            line+="$SPACE_CHAR"
        done
        # Print the entire row followed by a newline (if running in an environment that handles newlines)
        echo "$line"
    done
}

generate_visualizer
