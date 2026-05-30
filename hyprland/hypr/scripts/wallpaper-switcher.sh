#!/usr/bin/env bash

# 1. Source the environment file if it exists
# shellcheck source=/dev/null
[ -f ~/.cache/current_theme_env ] && source ~/.cache/current_theme_env

# 2. Fallback if the variable still isn't set
WALLPAPER_DIR="${CURRENT_THEME_BG:-$HOME/Pictures/wallpapers}"

if [ ! -d "$WALLPAPER_DIR" ]; then
  notify-send -u critical "Directory $WALLPAPER_DIR does not exist."
  exit 1
fi

# Selecting wallpaper
wallpaper=$(find "$WALLPAPER_DIR" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.webp" \) |
  awk -F/ '{print $NF "\0icon\x1f" $0}' |
  rofi -dmenu -i -p "" -location 0 \
    -show-icons \
    -theme-str 'window { width: 800px; }
                element-icon { size: 250px; }
                listview { columns: 3; lines: 1; spacing: 10px; }
                element { orientation: vertical; }
                element-text { horizontal-align: 0.5; }')

# Exit if no value is selected
[[ -z "$wallpaper" ]] && exit 0

# Important: Because Rofi now returns the "Display Text" (the basename),
# we must ensure we use the full path.
# To do this safely, we search for the full path based on the filename:
wallpaper_full_path=$(find "$WALLPAPER_DIR" -name "$wallpaper" -print | head -n1)

killall hyprpaper

# This is for multi-wallpaper
# printf "%b\n" "splash = false" >~/.config/hypr/hyprpaper.conf
# printf "%b\n" "ipc = true" >>~/.config/hypr/hyprpaper.conf
# monitors=$(hyprctl monitors -j | jq -r ".[] | .name")
# for monitor in $monitors; do
#   printf "%b" "wallpaper {
#   monitor = $monitor
#   path = $wallpaper_full_path
#   fit_mode=cover
# }" >>~/.config/hypr/hyprpaper.conf
# done

# Main Wallpaper Screen
sed -i "s|path = .*|path = $wallpaper_full_path|" "$XDG_CONFIG_HOME/hypr/hyprpaper.conf"
# Lock Screen
sed -i "s|path = .*|path = $wallpaper_full_path|" "$XDG_CONFIG_HOME/hypr/lock-background.conf"

notify-send -u low "Wallpaper Applied" "$wallpaper"
hyprctl dispatch 'hl.dsp.exec_cmd("hyprpaper")'
