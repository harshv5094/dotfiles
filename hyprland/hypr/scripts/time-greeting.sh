#!/usr/bin/env bash

# Get hour (00–23)
hour=$(date +"%H")

# Remove leading zero safely (POSIX)
case "$hour" in
0*) hour=${hour#0} ;;
esac

# Convert empty/00 to 0
[ -z "$hour" ] && hour=0

# Choose greeting
if [ "$hour" -lt 12 ]; then
  greeting="Good Morning"
elif [ "$hour" -lt 17 ]; then
  greeting="Good Afternoon"
else
  greeting="Good Evening"
fi

printf "%b" "$greeting"
