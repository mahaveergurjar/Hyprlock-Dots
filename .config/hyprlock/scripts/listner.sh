#!/bin/bash

tail -f /tmp/dunst_log | while read -r line; do
    echo "New Notification: $line"
    hyprctl hyprlock:text notify1 "$line"
done
