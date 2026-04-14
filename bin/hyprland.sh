#!/usr/bin/env bash
# Checking if script runner is root #
if [ "$(id -u)" -eq 0 ]; then
  printf "%b\n" "Please don't run this script as root!"
  exit 1
fi

# -- Global Variables -- #
source_dirs="$HOME/dotfiles"
if [[ ! -d "$source_dirs" ]]; then
  source_dirs="/tmp/dotfiles"
  git clone https://github.com/harshv5094/dotfiles "$source_dirs"
fi
XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
AUR_HELPER=$(command -v paru || command -v yay)
ESCALATION_TOOL=$(command -v sudo || command -v doas)

if ! command -v "$AUR_HELPER" &>/dev/null; then
  printf "%b\n" "Install $AUR_HELPER first to resume the setup script!"
  exit 1
fi

# -- Checking config directory -- #
if [[ ! -d $XDG_CONFIG_HOME ]]; then
  printf "%b\n" "$XDG_CONFIG_HOME doesn't exist. Creating $XDG_CONFIG_HOME"
  mkdir -p "$XDG_CONFIG_HOME"
else
  printf "%b\n" "$XDG_CONFIG_HOME exist."
fi

# -- Setup Config Folders -- #
copyFolders() {
  printf "%b\n" "** Copying my config directories **"
  hypr_conf_dirs=('hypr' 'mako' 'mpd' 'mpv'
    'nwg-look' 'qt5ct' 'qt6ct' 'rmpc'
    'rofi' 'waybar' 'themes' 'xdg-desktop-portal')
  for hypr_dir in "${hypr_conf_dirs[@]}"; do
    if [[ -d $XDG_CONFIG_HOME/$hypr_dir ]]; then
      printf "%b\n" "* $XDG_CONFIG_HOME/$hypr_dir exist!\nBacking Up $XDG_CONFIG_HOME/$hypr_dir *"
      mv "$XDG_CONFIG_HOME/$hypr_dir" "$XDG_CONFIG_HOME/${hypr_dir}.bak"

      printf "%b\n" "* Copying $hypr_dir to $XDG_CONFIG_HOME *"
      cp -rf "$source_dirs/hyprland/$hypr_dir" "$XDG_CONFIG_HOME"
    else
      printf "%b\n" "* Copying $hypr_dir to $XDG_CONFIG_HOME *"
      cp -rf "$source_dirs/hyprland/$hypr_dir" "$XDG_CONFIG_HOME"
    fi
  done
}

# -- Extract Colors -- #
extractGruvboxColors() {
  printf "%b\n" "** Clonning Gruvbox GTK Theme **"
  if [[ ! -d $HOME/Gruvbox-GTK-Theme ]]; then
    git clone https://github.com/Fausto-Korpsvart/Gruvbox-GTK-Theme "$HOME/Gruvbox-GTK-Theme"
  fi
  "$HOME/Gruvbox-GTK-Theme/themes/install.sh" -l
  sleep 0.4s
  rm -rf "$HOME/Gruvbox-GTK-Theme"
}

# -- My wallpapers -- #
cloneWallpapers() {
  if [[ ! -d $HOME/Pictures/wallpapers/ ]]; then
    printf "%b\n" "** Clonning My wallpapers **"
    git clone https://github.com/harshv5094/wallpapers "$HOME/Pictures/wallpapers/"
  else
    printf "%b\n" "** Backing up existing wallpaper directory **"
    mv "$HOME/Pictures/wallpapers/" "$HOME/Pictures/wallpapers.bak/"

    printf "%b\n" "** Clonning My wallpapers **"
    git clone https://github.com/harshv5094/wallpapers "$HOME/Pictures/wallpapers/"
  fi
}

# -- Setup my window manager -- #
loginSetup() {
  luksLoginSetup() {
    printf "%b" "** LOCKED: Root is encrypted **"
    printf "%b\n" "* Setting up LUKS login *"
    target_dir="/etc/systemd/system/getty@tty1.service.d"
    target_file="$target_dir/override.conf"
    config_content="[Service]\nExecStart=\nExecStart=-/usr/bin/agetty --noreset --noclear --autologin ${SUDO_USER:-$USER} - \${TERM}"
    [[ ! -d $target_dir ]] && $ESCALATION_TOOL mkdir -p "$target_dir"
    printf "%b\n" "$config_content" | $ESCALATION_TOOL tee "$target_file"

    #shellcheck disable=SC2016
    bash_profile_content='[[ -f $HOME/.bashrc ]] && source "$HOME/.bashrc"\n\nif [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then\n  echo -e "Starting Hyprland....\n"\n  sleep 1\n  start-hyprland\nfi\n'
    printf "%b" "$bash_profile_content" | tee "$HOME/.bash_profile"
    #shellcheck disable=SC2016
    zprofile_content='[[ -f ~/.zshrc ]] && . ~/.zshrc\n\nif [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then\n  echo -e "Starting Hyprland....\n"\n  sleep 1s\n  start-hyprland\nfi\n'
    printf "%b" "$zprofile_content" | tee "$HOME/.zprofile"
  }

  lyLoginManager() {
    printf "%b" "** OPEN: Root is not encrypted **"
    printf "%b\n" "* Setting Up Login Manager (Ly) *"
    $AUR_HELPER -S --noconfirm --needed ly

    managers=('sddm' 'gdm' 'lightdm' 'lxdm' 'lxdm-gtk3' 'mdm' 'nodm' 'xdm' 'entrance')

    for manager in "${managers[@]}"; do
      if $ESCALATION_TOOL systemctl is-active --quiet "$manager.service"; then
        printf "%b\n\n" "* Disabling $manager... *"
        $ESCALATION_TOOL systemctl disable "$manager"
      fi
    done

    printf "%b\n" "* Enabling Ly... *"
    # NOTE: https://codeberg.org/fairyglade/ly/releases/tag/v1.3.0
    $ESCALATION_TOOL systemctl disable getty@tty2.service
    $ESCALATION_TOOL systemctl enable ly@tty2.service

    printf "%b\n" "* Copying My Ly config files *"
    if [[ -d "/etc/ly/" ]]; then
      [[ -f "/etc/ly/config.ini" ]] && $ESCALATION_TOOL mv /etc/ly/config.ini /etc/ly/config.ini.bak
      $ESCALATION_TOOL cp -rf "${source_dirs}/hyprland/ly/config.ini" "/etc/ly/"
    fi

    printf "%b\n" "* Ly setup complete! *"
  }

  # Check if it is root or LUKS?
  if lsblk -no TYPE "$(findmnt -nvo SOURCE /)" | grep -q "crypt"; then
    luksLoginSetup
  else
    lyLoginManager
  fi

  # Changing some grub settings
  if [[ -f /etc/default/grub ]]; then
    printf "* Tweaking Grub Settings *"
    $AUR_HELPER -S --noconfirm --needed plymouth
    if ! grep -q "splash" /etc/default/grub; then
      $ESCALATION_TOOL sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 splash"/' /etc/default/grub
    fi
    $ESCALATION_TOOL sed -i 's/^GRUB_DEFAULT=.*/GRUB_DEFAULT=saved/' /etc/default/grub
    $ESCALATION_TOOL sed -i 's/^#GRUB_DISABLE_SUBMENU=.*/GRUB_DISABLE_SUBMENU=y/' /etc/default/grub
    $ESCALATION_TOOL sed -i 's/^#GRUB_SAVEDEFAULT=.*/GRUB_SAVEDEFAULT=true/' /etc/default/grub
    printf "* Generating Grub Config *"
    $ESCALATION_TOOL grub-mkconfig -o /boot/grub/grub.cfg
  fi

  # Change tty fonts to terminus
  if [[ -f /etc/vconsole.conf ]]; then
    printf "%b\n" "Changing tty font to terminus"
    $AUR_HELPER -S --noconfirm --needed terminus-font
    sed -i 's/FONT=.*/FONT=ter-v20b/' /etc/vconsole.conf
  fi
}

installAndConfigureHyprland() {
  packages_list=(
    # Hyprland packages
    "kitty" "hyprland" "hyprlock" "hypridle" "hyprpicker" "hyprpaper"
    "hyprutils" "hyprland-protocols" "hyprtoolkit" "hyprland-guiutils" "base-devel" "cpio" "cmake"
    "uwsm" "rofi" "xdg-desktop-portal-hyprland" "xdg-desktop-portal-gtk" "xdg-utils" "xdg-user-dirs" "xdg-user-dirs-gtk"
    # Base tools
    "wiremix" "brightnessctl" "iwd" "impala" "bluetui" "bluez" "bluez-utils" "playerctl" "gnome-keyring" "topgrade"
    "wl-clipboard" "copyq" "mako" "waybar" "mate-polkit" "mpd" "mpd-mpris" "mpc" "rmpc" "mpv" "nwg-look" "flatpak" "ncdu"
    "libgepub" "libopenraw" "breeze" "libadwaita" "qt5ct" "qt6ct" "qt6-wayland" "speech-dispatcher" "cronie" "usbutils"
    # GUI tools
    "firefox" "gnome-disk-utility" "gnome-characters" "easyeffects"
    "transmission-gtk" "seahorse" "timeshift" "gnome-calculator" "ristretto" "evince"
    # File Manager
    "thunar" "tumbler" "thunar-volman"
    "thunar-media-tags-plugin" "thunar-archive-plugin" "xarchiver"
    # Fonts & Icons
    "noto-fonts" "adwaita-icon-theme-legacy"
    "adwaita-icon-theme" "adwaita-cursors" "adwaita-fonts" "noto-fonts-emoji"
    "noto-fonts-extra" "ttf-jetbrains-mono-nerd" "inter-font" "ttf-firacode-nerd"
    "ttf-nerd-fonts-symbols" "ttf-nerd-fonts-symbols-common" "ttf-nerd-fonts-symbols-mono"
    "ttf-hanazono" "noto-fonts-cjk" "papirus-icon-theme" "otf-font-awesome"
    # AUR Packages
    "localsend" "grimblast-git" "xdg-terminal-exec-git"
  )

  printf "%b\n" "** Installing All Packages from list **"
  $AUR_HELPER -S --noconfirm --needed "${packages_list[@]}"

  printf "%b\n" "** Setting up XDG Default Directories **"
  xdg-user-dirs-update
  xdg-user-dirs-gtk-update

  printf "** Enable systemctl multiple user services **"
  user_services=("mpd.service" "mpd-mpris.service")
  for service in "${user_services[@]}"; do
    if ! systemctl --user is-active --quiet "$service"; then
      systemctl --user enable --now "$service"
    fi
  done

  printf "** Enable systemctl multiple system services **"
  system_services=("cronie.service")
  for service in "${system_services[@]}"; do
    if ! $ESCALATION_TOOL systemctl is-active --quiet "$service"; then
      $ESCALATION_TOOL systemctl enable --now "$service"
    fi
  done
}

printf "%b\n" "*** Starting Hyprland Setup **"
loginSetup
installAndConfigureHyprland
copyFolders
extractGruvboxColors
cloneWallpapers
printf "%b\n" "*** Hyprland Setup is finished **"
