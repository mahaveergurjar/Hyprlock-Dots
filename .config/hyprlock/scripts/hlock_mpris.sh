#!/bin/env bash

THUMB="/tmp/hyde-mpris"
THUMB_BLURRED="/tmp/hyde-mpris-blurred"
ART_INFO="${THUMB}.inf"

cleanup() {
    rm -f "${THUMB}"* "${THUMB_BLURRED}.png" "${ART_INFO}"
}

fetch_thumb() {
    # Check if Spotify is running
    playerctl -p spotify status &>/dev/null || { cleanup; exit 1; }

    # Get album art URL from Spotify
    artUrl=$(playerctl -p spotify metadata --format '{{mpris:artUrl}}' 2>/dev/null)
    [[ -z "$artUrl" ]] && exit 1

    # Skip processing if the URL hasn't changed
    [[ -f "$ART_INFO" && "$(cat "$ART_INFO")" == "$artUrl" ]] && return 0
    echo "$artUrl" > "$ART_INFO"

    # Download album art
    curl -sS "$artUrl" -o "${THUMB}.png" || exit 1
    magick "${THUMB}.png" -quality 50 "${THUMB}.png"

    # Create blurred background
    magick "${THUMB}.png" -blur 200x7 -resize 1920x^ -gravity center -extent 1920x1080 "${THUMB_BLURRED}.png"

    # Refresh Hyprlock
    pkill -USR2 hyprlock
}

# Ensure required commands exist
for cmd in playerctl curl magick pkill; do
    command -v "$cmd" &>/dev/null || { echo "Error: $cmd is required but not installed."; exit 1; }
done

# Run fetch_thumb in background if Spotify is playing, else cleanup
playerctl -p spotify status &>/dev/null && { 
    playerctl -p spotify metadata --format '{{title}}  {{artist}}' && fetch_thumb 
} || cleanup &

exit 0
