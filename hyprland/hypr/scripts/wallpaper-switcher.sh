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
  rofi -dmenu -i -p "" -location 2 \
    -show-icons \
    -theme-str 'window { width: 800px; margin: 5px; }
                element-icon { size: 200px; }
                listview { columns: 3; lines: 1; spacing: 10px; }
                element { orientation: vertical; }
                element-text { horizontal-align: 0.5; }')

# Exit if no value is selected
[[ -z "$wallpaper" ]] && exit 0

# Important: Because Rofi now returns the "Display Text" (the basename),
# we must ensure we use the full path.
# To do this safely, we search for the full path based on the filename:
wallpaper_full_path=$(find "$WALLPAPER_DIR" -name "$wallpaper" -print | head -n1)

hyprctl hyprpaper unload all
killall hyprpaper

printf "%b\n" "splash = false" >~/.config/hypr/hyprpaper.conf
printf "%b\n" "ipc = true" >>~/.config/hypr/hyprpaper.conf

# monitors=$(hyprctl monitors -j | jq -r ".[] | .name")
# for monitor in $monitors; do
#   printf "%b" "wallpaper {
#   monitor = $monitor
#   path = $wallpaper
#   fit_mode=cover
# }" >>~/.config/hypr/hyprpaper.conf
# done

printf "%b" "wallpaper {
    monitor =
    path = $wallpaper_full_path
    fit_mode=cover
}" >>~/.config/hypr/hyprpaper.conf

printf "%b" "# BACKGROUND
background { 
    blur_size = 3
    blur_passes = 2
    contrast = 1
    brightness = 0.5
    vibrancy = 0.2
    vibrancy_darkness = 0.2
    path = $wallpaper_full_path   # supports png, jpg, webp (no animations, though)
}
" >~/.config/hypr/sections/lock-background.conf

notify-send "Wallpaper Applied" "$wallpaper"
hyprctl dispatch exec hyprpaper
