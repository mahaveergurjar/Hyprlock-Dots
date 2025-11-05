#!/bin/bash

# Configuration
player="spotify"
# Reduced bar length for smaller size, as requested.
BAR_LENGTH=10 
# Define colors using Pango/HTML for use in Hyprlock's label
COLOR_PLAYED="#1DB954" # Spotify Green or a nice accent color
COLOR_REMAINING="#FFFFFF40" # Light gray, slightly transparent
SPACE_CHAR="—" # Subtle, smooth line character for the bar track

# Handle Character (Static)
STATIC_HANDLE="⦿" 

# Cache files
CACHE_FILE="/tmp/hyprlock_mpris_pos.cache"
CACHE_ID_FILE="/tmp/hyprlock_mpris_id.cache"

# Function to find the currently playing player if 'spotify' isn't available
find_player() {
    # Try the default player first
    status=$(playerctl -p "$player" status 2>/dev/null)
    if [[ "$status" == "Playing" || "$status" == "Paused" ]]; then
        echo "$player"
        return 0
    fi

    # Fallback to any available player
    local active_player=$(playerctl -l 2>/dev/null | head -n 1)
    if [ -n "$active_player" ]; then
        echo "$active_player"
    fi
}

# Function to get metadata using playerctl
get_metadata() {
    # Use the discovered player in case spotify is not the active one
    local current_player=$1
    local key=$2
    playerctl -p "$current_player" metadata "$key" 2>/dev/null
}

# Function to get status and position
get_status_and_position() {
    # 1. Determine which player to query
    local current_player=$(find_player)
    
    # Exit if no player is found or active
    if [ -z "$current_player" ]; then
        echo ""
        # Clean up cache files when music stops
        rm -f "$CACHE_FILE" "$CACHE_ID_FILE"
        exit 0
    fi

    local status=$(playerctl -p "$current_player" status 2>/dev/null)
    
    # Exit if player is not playing or paused
    if [[ "$status" != "Playing" && "$status" != "Paused" ]]; then
        echo ""
        # Clean up cache files
        rm -f "$CACHE_FILE" "$CACHE_ID_FILE"
        exit 0
    fi

    # 2. Get raw position, length, and track ID
    # Use || echo 0 to ensure the variable is always a number
    pos_raw=$(playerctl -p "$current_player" position 2>/dev/null | cut -d '.' -f1 || echo 0)
    length_raw=$(get_metadata "$current_player" "mpris:length" | cut -d '.' -f1 || echo 0)
    current_track_id=$(get_metadata "$current_player" "mpris:trackid")
    
    # 3. Handle zero length or invalid state
    if [[ "$length_raw" -le 0 ]]; then
        echo "" # Output empty string
        rm -f "$CACHE_FILE" "$CACHE_ID_FILE"
        exit 0
    fi

    # Read last track ID and cached position (in microseconds)
    local last_track_id=$(cat "$CACHE_ID_FILE" 2>/dev/null || echo "")
    # Check if cache file exists and is readable, otherwise default to 0
    local last_cached_pos=$( [ -f "$CACHE_FILE" ] && cat "$CACHE_FILE" || echo 0 )
    
    # Decide which position to use (pos_to_use)
    if [[ "$current_track_id" != "$last_track_id" ]]; then
        # NEW TRACK: Always start with the reported raw position
        pos_to_use=$pos_raw
    else
        # SAME TRACK: Apply stable advancement logic
        if [[ "$status" == "Playing" ]]; then
            # If the current reported raw position is significantly ahead of the cache, trust the raw position.
            # This handles seeking/jumping forward in the song. (Difference > 2 seconds)
            if (( pos_raw > last_cached_pos + 2000000 )); then
                pos_to_use=$pos_raw
            # If the reported position is stuck (less than 2 seconds ahead of cache), force advance by 1 second.
            else
                pos_to_use=$(( last_cached_pos + 1000000 ))
            fi
        else
            # Paused: Use the last known position (either cache or reported raw)
            # This ensures the pause state is stable.
            pos_to_use=$pos_raw
        fi
    fi

    # Ensure pos_to_use doesn't exceed length
    if (( pos_to_use > length_raw )); then
        pos_to_use=$length_raw
        # Clear cache once song ends to prevent advancing position on a stopped player
        rm -f "$CACHE_FILE"
    fi

    # Update cache for the next run
    echo "$current_track_id" > "$CACHE_ID_FILE"
    echo "$pos_to_use" > "$CACHE_FILE"

    # Time for display (converted to seconds)
    local pos_sec=$(( pos_to_use / 1000000 ))
    local length_sec=$(( length_raw / 1000000 ))

    # 4. Calculate progress using high-precision microseconds
    progress=$(( pos_to_use * BAR_LENGTH / length_raw ))
    
    # Clamp progress to max bar length
    if (( progress > BAR_LENGTH )); then
        progress=$BAR_LENGTH
    fi
    
    # Ensure progress is at least 1 if the song is playing
    if [[ "$status" == "Playing" && "$progress" -eq 0 && "$BAR_LENGTH" -gt 0 ]]; then
        progress=1
    fi

    # 5. Build the progress bar string using Pango/HTML markup
    # Part 1: Played track
    bar_played=""
    for ((i=0; i<progress; i++)); do
        bar_played+="$SPACE_CHAR"
    done

    # Part 2: Remaining track (starts one character after the played bar to accommodate the handle)
    bar_remaining=""
    # We loop from progress + 1 to BAR_LENGTH to reserve a spot for the STATIC_HANDLE
    for ((i=progress + 1; i<=BAR_LENGTH; i++)); do
        bar_remaining+="$SPACE_CHAR"
    done
    
    # The handle is placed at the end of the played bar
    # If the bar is full, we use the Played color for the entire bar
    if (( progress == BAR_LENGTH )); then
        final_bar="<span foreground=\"$COLOR_PLAYED\">${bar_played}${SPACE_CHAR}</span>"
    else
        final_bar="<span foreground=\"$COLOR_PLAYED\">$bar_played</span><span foreground=\"#ffffff\">$STATIC_HANDLE</span><span foreground=\"$COLOR_REMAINING\">$bar_remaining</span>"
    fi


    # 6. Format time (m:ss)
    format_time() {
        local m=$(( $1 / 60 ))
        local s=$(( $1 % 60 ))
        printf "%d:%02d" "$m" "$s"
    }

    pos_fmt=$(format_time "$pos_sec")
    len_fmt=$(format_time "$length_sec")

    # Output the result: [ Bar with Handle ] Time
    echo "$final_bar $pos_fmt / $len_fmt"
}

get_status_and_position
