#!/usr/bin/env bash

# Base Package setup
have() { command -v "$1" &>/dev/null; }

cat <<'EOF'
 _                          _         
| |                        | |        
| |__   __ _ ___  ___ _ __ | | ____ _ 
| '_ \ / _` / __|/ _ \ '_ \| |/ / _` |
| |_) | (_| \__ \  __/ |_) |   < (_| |
|_.__/ \__,_|___/\___| .__/|_|\_\__, |
                     | |         __/ |
                     |_|        |___/ 
EOF

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

if have pacman; then
  $ESCALATION_TOOL pacman -S --needed --noconfirm stow tree git github-cli \
    wget curl zip unzip ripgrep fzf sox bat eza lazygit btop fd \
    zoxide yt-dlp xsel fastfetch openssh tldr ncdu \
    trash-cli usbutils imagemagick man-db vdpauinfo \
    starship bash-completion neovim base-devel pass jq tmux cmake net-tools e2fsprogs pacman-contrib devtools
elif have apt; then
  $ESCALATION_TOOL apt update && $ESCALATION_TOOL apt upgrade
  $ESCALATION_TOOL apt install -y stow neovim tree pass git gh starship trash-cli \
    bat eza ripgrep curl wget fzf zoxide build-essential jq zip unzip \
    starship zoxide fastfetch make cmake bash-completion net-tools e2fsprogs
elif have dnf; then
  $ESCALATION_TOOL dnf groupinstall -y "Development Tools"
  $ESCALATION_TOOL dnf install -y stow neovim tree pass git gh starship trash-cli bat \
    eza ripgrep jq zip unzip zoxide starship fastfetch make cmake bash-completion net-tools e2fsprogs
else
  printf "%b\n" "No supported package manager found (pacman, apt, dnf). Exiting."
  exit 1
fi
