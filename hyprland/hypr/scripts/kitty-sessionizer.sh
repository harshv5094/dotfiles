#!/usr/bin/env bash

have() { command -v "$1" &>/dev/null; }

# Define a persistent cache directory
CACHE_DIR="$HOME/.cache/kitty-sessions"
[[ ! -d $CACHE_DIR ]] && mkdir -p "$CACHE_DIR"

if ! have kitty; then
  notify-send "Kitty Sessionizer" "Please install kitty first to use this script"
  exit 1
fi

if [ "$#" -eq 1 ]; then
  selected=$1
else
  selected=$(
    find ~/dev/* -mindepth 1 -maxdepth 1 -type d -not -path '*/.git*' | rofi -dmenu -i -p "" -location 0 \
      -theme-str 'window { width: 600px; }
                  listview { columns: 1; lines: 5; spacing: 10px; }
                  element { orientation: vertical; }
                  element-icon { size: 250px; }
                  element-text { horizontal-align: 0.5; }'
  )
fi

if [ -z "$selected" ]; then
  exit 0
fi

selected_name=$(basename "$selected" | tr '.' '_')
session_file="$CACHE_DIR/$selected_name"

cat >"$session_file" <<EOF
# Tab 1: Neovim
new_tab editor
cd $selected
launch nvim .

# Tab 2: Terminal
new_tab terminal
cd $selected
launch bash
EOF

kitty --session "$session_file" --detach
[[ "$?" -eq 0 ]] && notify-send -u low "Kitty Sessionizer" "Session: $selected_name"
