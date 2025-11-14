#!/usr/bin/env sh

have() { command -v "$1" >/dev/null 2>&1; }

# Check for sudo execution
if [ "$(id -u)" -eq 0 ]; then
  printf "%b\n" "Should not be run as root!"
  exit 1
fi

# Global Variables #
DOTFILES_DIR="$HOME/dotfiles"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
HYPR_FOLDERS="hypr rofi xdg-desktop-portal mako waybar nwg-look qt6ct"

# Copying My Folders #
if [ ! -d "$DOTFILES_DIR" ]; then
  printf "%b\n" "** Copying My Folders to $XDG_CONFIG_HOME"
  for folder in $HYPR_FOLDERS; do
    cp -rf "$DOTFILES_DIR/hyprland/$folder" "$XDG_CONFIG_HOME"
  done
else
  git clone --depth=1 https://github.com/harshv5094/dotfiles /tmp/dotfiles
  printf "%b\n" "** Copying My Folders to $XDG_CONFIG_HOME"
  for folder in $HYPR_FOLDERS; do
    cp -rf "/tmp/dotfiles/hyprland/$folder" "$XDG_CONFIG_HOME"
    DOTFILES_DIR="/tmp/dotfiles/hyprland/$folder"
  done
fi

# Install Packages #
if have paru; then
  sleep 2s
  printf "%b\n" "** Setting Up Login Manager (Ly) **"
  paru -S --noconfirm ly

  LOGIN_MANAGERS="sddm gdm lightdm lxdm lxdm-gtk3 mdm nodm xdm entrance"

  for login_manager in $LOGIN_MANAGERS; do
    if systemctl list-unit-files | grep -q "^${login_manager}\.service"; then
      if sudo systemctl --is-active --quiet "$login_manager"; then
        printf "%b\n" "* Disabling $login_manager... *"
        sudo systemctl disable "$login_manager"
        sudo systemctl stop "$login_manager"
      fi
    fi
  done

  printf "%b\n" "* Enabling Ly... *"
  sudo systemctl enable ly.service

  printf "%b\n" "* Copying My Ly config files *"
  if [ -e /etc/ly ]; then
    sudo cp -rf "$DOTFILES_DIR/extras/ly/config.ini" "/etc/ly/"
  fi

  printf "%b\n" "* Ly setup complete! *"

  sleep 2s
  printf "%b\n" "*** Starting Hyprland Setup() **"

  sleep 2s
  printf "%b\n" "** Installing Hyprland Packages **"
  paru -S --noconfirm kitty hyprland hyprlock hypridle hyprpicker hyprpaper uwsm rofi xdg-desktop-portal-hyprland xdg-desktop-portal-gtk

  sleep 2s
  printf "%b\n" "** Installing Base tools **"
  paru -S --noconfirm pavucontrol brightnessctl playerctl network-manager-applet gnome-keyring power-profiles-daemon \
    wl-clipboard copyq mako blueman bluez bluez-utils waybar mate-polkit nwg-look \
    xdg-utils xdg-user-dirs xdg-user-dirs-gtk gnome-themes-extra breeze qt6ct qt6-wayland speech-dispatcher

  sleep 2s
  printf "%b\n" "** Installing GUI tools **"
  paru -S --noconfirm firefox gnome-disk-utility gnome-tweaks gnome-text-editor gnome-clocks gnome-characters \
    transmission-gtk seahorse rhythmbox loupe timeshift evince transmission-gtk baobab \
    gnome-calculator totem gimp

  sleep 2s
  printf "%b\n" "** Installing File Manager **"
  paru -S --noconfirm thunar tumbler libgepub libopenraw thunar-volman thunar-media-tags-plugin thunar-archive-plugin xarchiver

  sleep 2s
  printf "%b\n" "** Installing Fonts & Icons **"
  paru -S --noconfirm noto-fonts noto-fonts-emoji noto-fonts-extra ttf-jetbrains-mono-nerd inter-font ttf-firacode-nerd \
    ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-common ttf-nerd-fonts-symbols-mono ttf-hanazono noto-fonts-cjk papirus-icon-theme otf-font-awesome

  sleep 2s
  printf "%b\n" "** Installing Hyprland Plugins **"
  paru -S --noconfirm grimblast-git

  sleep 2s
  printf "%b\n" "** Install AUR Packages **"
  paru -S --noconfirm visual-studio-code-bin localsend-bin

  sleep 2s
  printf "%b\n" "** Setting up XDG Default Directories **"
  xdg-user-dirs-update

  sleep 2s
  printf "%b\n" "** Setting up XDG GTK Default Directories **"
  xdg-user-dirs-gtk-update
else
  printf "%b\n" "** Install Paru First! **"
  exit 1
fi

printf "%b\n" "*** Hyprland Setup is Finished ***"
