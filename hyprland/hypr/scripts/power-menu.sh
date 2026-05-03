#!/usr/bin/env bash

# Define the menu options
options="Lock\nLogout\nHibernate\nReboot\nPoweroff\nSuspend"

# Show the menu using Rofi
choice=$(printf "%b" "$options" |
  rofi -dmenu -i -p "⏻ " -location 2 \
    -theme-str 'window { width: 180px; margin: 5px; }
                mainbox { children: [listview]; }
                listview { columns: 1; lines: 3; spacing: 10px; }
                element { orientation: horizontal; }
                element-text { horizontal-align: 0.5; }')

case "$choice" in
Lock)
  # Lock the screen
  hyprctl dispatch exec hyprlock
  ;;
Logout)
  # Log out
  hyprctl dispatch exit
  ;;
Hibernate)
  # Hibernate the system
  systemctl hibernate
  ;;
Reboot)
  # Reboot the system
  systemctl reboot
  ;;
Poweroff)
  # Shutdown the system
  systemctl poweroff
  ;;
Suspend)
  systemctl suspend
  ;;
*)
  # Exit without doing anything
  exit 0
  ;;
esac
