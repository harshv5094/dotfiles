#!/usr/bin/env sh

# Base Package setup
have() { command -v "$1" >/dev/null 2>&1; }

printf "%b\n" "** Installing required CLI tools **"

# Detect escalation tool (sudo, doas, or none if root)
if [ "$(id -u)" -eq 0 ]; then
  ESCALATION_TOOL="" # already root
elif have sudo; then
  ESCALATION_TOOL="sudo"
elif have doas; then
  ESCALATION_TOOL="doas"
else
  printf "%b\n" "No privilege escalation tool (sudo/doas) found and not running as root."
  exit 1
fi

# Detect package manager
if have pacman; then
  package_manager="pacman"
elif have apt; then
  package_manager="apt"
elif have dnf; then
  package_manager="dnf"
else
  printf "%b\n" "No supported package manager found (pacman, apt, dnf). Exiting."
  exit 1
fi

# Install required packages
if command -v flatpak >/dev/null; then
  printf "%b\n" "Flatpak is installed"
  flatpak install com.github.tchx84.Flatseal com.rtosta.zapzap com.brave.Browser org.telegram.desktop com.discordapp.Discord
else
  case "$package_manager" in
  pacman)
    $ESCALATION_TOOL pacman -S --needed --noconfirm flatpak
    ;;
  apt)
    $ESCALATION_TOOL apt update && $ESCALATION_TOOL apt upgrade
    $ESCALATION_TOOL apt install -y flatpak
    ;;
  dnf)
    $ESCALATION_TOOL dnf install -y flatpak
    ;;
  esac

  if [ $? -eq 0 ]; then
    printf "%b\n" "Flatpak is installed. Restart the system and run this script again to install apps."
  fi

fi
