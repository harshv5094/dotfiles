#!/usr/bin/env bash

# Try to get info from playerctl
song_info=$(playerctl metadata --format '{{title}} / {{artist}}')

# If playerctl returned nothing, try MPD via mpc
if [ -z "$song_info" ]; then
  # mpc outputs "Title - Artist" as default
  mpd_title=$(mpc --format "%title%" current)
  mpd_artist=$(mpc --format "%artist%" current)

  if [ -n "$mpd_title" ] || [ -n "$mpd_artist" ]; then
    song_info="$mpd_title / $mpd_artist"
  fi
fi

printf "%b" "$song_info"
