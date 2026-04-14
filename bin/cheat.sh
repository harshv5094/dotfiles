#!/usr/bin/env bash

if [[ -n "$1" ]]; then
  curl "cheat.sh/$1"
else
  echo "Usage: cheat.sh <query>"
fi
