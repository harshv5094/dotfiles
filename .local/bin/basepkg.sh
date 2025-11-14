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
case "$package_manager" in
pacman)
  $ESCALATION_TOOL pacman -S --needed --noconfirm stow fish tree git ghq github-cli git-lfs \
    wget curl zip unzip peco ripgrep fzf sox bat eza lazygit btop fd \
    zoxide yt-dlp xsel fastfetch openssh tldr \
    trash-cli usbutils cronie imagemagick man-db vdpauinfo \
    starship bash-completion neovim go rust base-devel luarocks pass jq tmux \
    make cmake
  ;;
apt)
  $ESCALATION_TOOL apt update && $ESCALATION_TOOL apt upgrade
  $ESCALATION_TOOL apt install -y stow neovim tree pass git gh starship bat eza ripgrep curl wget fzf zoxide bash-completion build-essential jq zip unzip starship zoxide fastfetch make cmake
  ;;
dnf)
  $ESCALATION_TOOL dnf groupinstall -y "Development Tools"
  $ESCALATION_TOOL dnf install -y stow neovim tree pass git gh starship bat eza ripgrep jq zip unzip zoxide starship fastfetch make cmake
  ;;
esac
