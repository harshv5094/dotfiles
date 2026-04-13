#!/usr/bin/env bash

# Define a persistent cache directory
CACHE_DIR="$HOME/.cache/kitty-sessions"
[[ ! -d $CACHE_DIR ]] && mkdir -p "$CACHE_DIR"

if [ "$#" -eq 1 ]; then
  selected=$1
else
  selected=$(
    find ~/dev/* -mindepth 1 -maxdepth 1 -type d -not -path '*/.git*' | fzf --style full --layout=reverse \
      --border --padding 1,2 \
      --border-label '** Kitty Sessionizer **' --input-label ' Input ' --header-label ' File Type ' \
      --bind 'focus:transform-header:file --brief {}' \
      --bind 'alt-j:down,alt-k:up' \
      --preview "tree -C --noreport -L 1 {}" \
      --preview-window=right:40%:wrap \
      --ansi
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

# Tab 2: Neovim
new_tab git
cd $selected
launch lazygit

# Tab 3: Terminal
new_tab terminal
cd $selected
launch bash
EOF

kitty --session "$session_file" --detach
[[ "$?" -eq 0 ]] && notify-send -u low "Kitty Sessionizer" "Session: $selected_name"
