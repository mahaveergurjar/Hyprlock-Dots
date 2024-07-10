#!/bin/env bash

THUMB=/tmp/hyde-mpris
THUMB_BLURRED=/tmp/hyde-mpris-blurred
THUMB_RECTANGLE=/tmp/blurred_rectangle.png

fetch_thumb() {
  artUrl=$(playerctl -p spotify metadata --format '{{mpris:artUrl}}') 
  [[ "${artUrl}" = "$(cat "${THUMB}.inf")" ]] && return 0

  printf "%s\n" "$artUrl" > "${THUMB}.inf"

  curl -so "${THUMB}.png" "$artUrl"
  magick "${THUMB}.png" -quality 50 "${THUMB}.png"
  # Create blurred version
  magick "${THUMB}.png" -blur 200x7 -resize 1920x^ -gravity center -extent 1920x1080\! "${THUMB_BLURRED}.png"
  magick -size 800x200 xc:none -fill black -draw "rectangle 0,0 800,200" -blur 0x3 "${THUMB_RECTANGLE}"
# fi
  pkill -USR2 hyprlock
}

# if [ ! -f "${THUMB_RECTANGLE}" ]; then
#     magick -size 800x200 xc:none -fill black -draw "rectangle 0,0 800,200" -blur 0x3 "${THUMB_RECTANGLE}"
# fi

# Run fetch_thumb function in the background
{ playerctl -p spotify metadata --format '{{title}}    {{artist}}'  && fetch_thumb ;} || { rm -f "${THUMB}*" && exit 1;} &

