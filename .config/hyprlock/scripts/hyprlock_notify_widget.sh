#!/bin/bash

CONFIG="$HOME/.config/hypr/hyprlock.conf"
TEXT="$1"

SAFE_TEXT=$(echo "$TEXT" | sed 's/"/\\"/g')

# Update 'NOTIFICATION' label block text
awk -v msg="$SAFE_TEXT" '
/label {/,/}/ {
    if ($0 ~ /# NOTIFICATION/) notify_block=1
}
notify_block && /text =/ {
    $0 = "text = \"" msg "\""
    notify_block=0
}
{ print }
' "$CONFIG" > "$CONFIG.tmp" && mv "$CONFIG.tmp" "$CONFIG"

# Lock screen with updated message
pkill hyprlock
hyprlock &
