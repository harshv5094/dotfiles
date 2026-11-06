#!/usr/bin/env bash

# Define your waybar position here
options="top\nbottom"

# The target file
file="$HOME/.config/waybar/config.jsonc"

# Show the menu using Rofi
choice=$(printf "%b" "$options" |
  rofi -dmenu -i -p " " -location 0 \
    -theme-str 'window { width: 180px; }
                listview { columns: 1; lines: 2; spacing: 10px; }
                element { orientation: horizontal; }
                element-text { horizontal-align: 0.5; }')

if [ -z "$choice" ]; then
  exit 1
fi

if [ -f "$file" ]; then
  sed -i "s/\"position\": \".*\"/\"position\": \"$choice\"/" "$file"
  pkill waybar && hyprctl dispatch 'hl.exec_cmd("waybar")'
  notify-send -u low "Waybar" "Position: $choice"
else
  notify-send "Not found - $file" "It doesn't exist in the directory"
  exit 1
fi
