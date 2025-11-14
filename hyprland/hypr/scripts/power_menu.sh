#!/usr/bin/env sh

# Define the menu options
options="Lock\nLogout\nHibernate\nReboot\nShutdown\nSuspend"

# Show the menu using Rofi
choice=$(printf "%b" "$options" | rofi -dmenu -i -p "⏻ " -lines 5 -width 20)

case "$choice" in
Lock)
  # Lock the screen
  hyprctl dispatch exec hyprlock
  ;;
Logout)
  # Log out
  hyprctl dispatch exit 0
  ;;
Hibernate)
  # Hibernate the system
  systemctl hibernate
  ;;
Reboot)
  # Reboot the system
  systemctl reboot
  ;;
Shutdown)
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
