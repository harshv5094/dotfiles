#!/usr/bin/env bash

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

CONFIG_FILE="$XDG_CONFIG_HOME/hypr/hyprland.lua"
TARGET_LINE='require("sections.smart_gaps")'

# shellcheck disable=SC2001
if grep -q "^$(echo "$TARGET_LINE" | sed 's/\./\\./g')" "$CONFIG_FILE"; then
  sed -i "s|^${TARGET_LINE}$|-- &|" "$CONFIG_FILE"
  notify-send -u low "Smart Gaps" "Off"
else
  sed -i "s|^\s*--\s*${TARGET_LINE}$|${TARGET_LINE}|" "$CONFIG_FILE"
  notify-send -u low "Smart Gaps" "On"
fi
