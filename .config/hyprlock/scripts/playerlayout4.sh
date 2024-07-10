#!/bin/env bash

THUMB=/tmp/hyde-mpris
THUMB_BLURRED=/tmp/hyde-mpris-blurred

if [ $# -eq 0 ]; then
    echo "Usage: $0 --title | --arturl | --artist | --position | --length | --album | --source"
    exit 1
fi

# Function to get metadata using playerctl
get_metadata() {
    key=$1
    playerctl metadata --format "{{ $key }}" 2>/dev/null
    

}

# Function to determine the source and return an icon and text
get_source_info() {
    trackid=$(get_metadata "mpris:trackid")
    if [[ "$trackid" == *"firefox"* ]]; then
        echo -e "Firefox 󰈹"
    elif [[ "$trackid" == *"spotify"* ]]; then
        echo -e "Spotify "
    elif [[ "$trackid" == *"chromium"* ]]; then
        echo -e "Chrome "
    elif [[ "$trackid" == *"YoutubeMusic"* ]]; then
        echo -e "YouTubeMusic "
    else
        echo ""
    fi
}

# Function to get position using playerctl
get_position() {
    playerctl position 2>/dev/null
}

# Function to convert microseconds to minutes and seconds
convert_length() {
    local length=$1
    local seconds=$((length / 1000000))
    local minutes=$((seconds / 60))
    local remaining_seconds=$((seconds % 60))
    printf "%d:%02d m" $minutes $remaining_seconds
}

# Function to convert seconds to minutes and seconds
convert_position() {
    local position=$1
    local seconds=${position%.*} # Remove fractional part if exists
    local minutes=$((seconds / 60))
    local remaining_seconds=$((seconds % 60))
    printf "%d:%02d" $minutes $remaining_seconds
}

# Function to fetch album art and create blurred version
fetch_thumb() {
    artUrl=$(playerctl -p spotify metadata --format '{{mpris:artUrl}}') 
    [[ "${artUrl}" = "$(cat "${THUMB}.inf")" ]] && return 0

    printf "%s\n" "$artUrl" > "${THUMB}.inf"

    curl -so "${THUMB}.png" "$artUrl"
    magick "${THUMB}.png" -quality 50 "${THUMB}.png"
    # Create blurred version
    pkill -USR2 hyprlock
}

# Run fetch_thumb function in the background
{ fetch_thumb ;} || { rm -f "${THUMB}*" && exit 1;} &

# Parse the argument
case "$1" in
--title)
    title=$(get_metadata "xesam:title")
    if [ -z "$title" ]; then
        echo ""
    else
        echo "${title:0:50}" # Limit the output to 50 characters
    fi
    ;;
# --arturl)
#     fetch_thumb & # Run fetch_thumb in the background
#     url=$(get_metadata "mpris:artUrl")
#     if [[ "$(playerctl -p status)" != "Playing"  ]]; then
#           rm -f /tmp/hyde-mpris*
#     fi
#      ;;
--artist)
    artist=$(get_metadata "xesam:artist")
    if [ -z "$artist" ]; then
        echo ""
    else
        echo "${artist:0:50}" # Limit the output to 50 characters
    fi
    ;;
--position)
    position=$(get_position)
    length=$(get_metadata "mpris:length")
    if [ -z "$position" ] || [ -z "$length" ]; then
        echo ""
    else
        position_formatted=$(convert_position "$position")
        length_formatted=$(convert_length "$length")
        echo "$position_formatted/$length_formatted"
    fi
    ;;
--length)
    length=$(get_metadata "mpris:length")
    if [ -z "$length" ]; then
        echo ""
    else
        convert_length "$length"
    fi
    ;;
--status)
    status=$(playerctl status 2>/dev/null)
    if [[ $status == "Playing" ]]; then
        echo "󰎆"
    elif [[ $status == "Paused" ]]; then
        echo "󱑽"
    else
        echo ""
    fi
    ;;
--album)
    album=$(playerctl metadata --format "{{ xesam:album }}" 2>/dev/null)
    if [[ -n $album ]]; then
        echo "$album"
    else
        status=$(playerctl status 2>/dev/null)
        if [[ -n $status ]]; then
            echo "Not album"
        else
            echo ""
        fi
    fi
    ;;
--source)
    get_source_info
    ;;
*)
    echo "Invalid option: $1"
    echo "Usage: $0 --title | --arturl | --artist | --position | --length | --album | --source" ; exit 1
    ;;
esac
