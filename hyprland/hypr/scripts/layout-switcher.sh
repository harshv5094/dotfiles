#!/usr/bin/env bash

# Define the menu options
options="dwindle\nmaster\nscrolling"

file="$HOME/.config/hypr/hypr.d/layouts.conf"

# Show the menu using Rofi
choice=$(printf "%b" "$options" |
  rofi -dmenu -i -p " " -location 0 \
    -theme-str 'window { width: 180px; }
                listview { columns: 1; lines: 3; spacing: 10px; }
                element { orientation: horizontal; }
                element-text { horizontal-align: 0.5; }')

if [ -z "$choice" ]; then
  exit 1
fi

if [ -f "$file" ]; then
  sed -i "s/layout = .*/layout = $choice/" "$file"
else
  notify-send "Not found - $file" "It doesn't exist in the directory"
  exit 1
fi
