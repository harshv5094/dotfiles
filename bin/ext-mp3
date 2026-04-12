#!/usr/bin/env bash

music_directory="$HOME/Music/"

if [ ! -d "${music_directory}" ]; then
  mkdir -p "${music_directory}"
fi

if command -v yt-dlp &>/dev/null; then
  # Check if a file argument is provided
  if [ "$#" -ne 1 ]; then
    printf "%b\n" "Usage: ext-mp3 <URL>"
    exit 1
  fi

  yt-dlp -x \
    --audio-format mp3 \
    --audio-quality 0 \
    --convert-thumbnails jpg \
    --ppa "ThumbnailsConvertor+ffmpeg_o:-vf crop='ih:ih'" \
    --embed-thumbnail \
    --embed-metadata \
    --sponsorblock-remove all \
    --parse-metadata "%(title)s:%(title)s" \
    --parse-metadata "%(uploader)s:%(artist)s" \
    --output "${music_directory}%(title)s.%(ext)s" \
    "$1"
  exit 0

else
  printf "%b\n" "yt-dlp not found. Install it first."
  exit 1
fi
