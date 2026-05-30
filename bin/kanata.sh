#!/usr/bin/env bash

# --- Global Directories --- #
SYSTEMD_USER="$HOME/.config/systemd/user/"
CLONE_DIR="/tmp/home-row-mods"
KANATA_DIR="$HOME/.config/kanata"
AUR_HELPER=$(command -v paru || command -v yay)

# --- Command Checker --- #
have() { command -v "$1" &>/dev/null; }

cat <<'EOF'
 _   __                  _        
| | / /                 | |       
| |/ /  __ _ _ __   __ _| |_ __ _ 
|    \ / _` | '_ \ / _` | __/ _` |
| |\  \ (_| | | | | (_| | || (_| |
\_| \_/\__,_|_| |_|\__,_|\__\__,_|
                                  
                                  
EOF

# --- Clonning Repo Mechanism --- #
cloneRepo() {
  if [ ! -d "$CLONE_DIR" ]; then
    printf "%b\n" "${CLONE_DIR} directory doesn't exist. Cloning directory"
    git clone https://github.com/harshv5094/home-row-mods "$CLONE_DIR"
  else
    printf "%b\n" "Location: ${CLONE_DIR} "
  fi
}

# --- Main Keymods Setup function --- #
setupKanata() {
  # NOTE: Installing Kanata Package
  if have "$AUR_HELPER"; then
    printf "%b\n" "**Installing kanata from $AUR_HELPER**"
    if grep -qE '\[chaotic-aur\]' '/etc/pacman.conf'; then
      printf "%b\n" "** Installing kanata from Chaotic AUR **"
      $AUR_HELPER -S --noconfirm kanata
    else
      printf "%b\n" "** Installing kanata Binary AUR package **"
      $AUR_HELPER -S --noconfirm kanata-bin
    fi
  else
    printf "%b\n" "**Please install $AUR_HELPER aur helper first**"
    exit 1
  fi

  # NOTE: Creating `uinput` and `input` group
  printf "%b\n" "Creating group uinput and input "
  # List of groups to check
  for group in uinput input; do
    if getent group "$group" >/dev/null; then
      printf "%b\n" "Group '$group' exists. Deleting the group and recreating it"
      # Explicitly use sudo for group modification commands
      sudo groupdel "$group"
      sudo groupadd --system "$group"
    else
      printf "%b\n" "Group '$group' does not exist. Creating it."
      sudo groupadd --system "$group"
    fi
  done

  # NOTE: Adding $USER to `uinput` and `input`
  printf "%b\n" "Adding group uinput and input to user $USER "
  sudo usermod -aG uinput "$USER"
  sudo usermod -aG input "$USER"

  printf "%b\n" "Copying rules file"
  sudo cp -rf "$CLONE_DIR/linux/kanata/99-input.rules" /etc/udev/rules.d/

  printf "%b\n" "Reloading Rules"
  sudo udevadm control --reload-rules && sudo udevadm trigger

  printf "%b\n" "Verifying uinput file"
  ls -l /dev/uinput

  printf "%b\n" "Loading uinput drivers"
  sudo modprobe uinput

  if [ -d "$SYSTEMD_USER" ]; then
    printf "%b\n" "Copying Service file"
    cp -rf "$CLONE_DIR/linux/kanata/kanata.service" "$SYSTEMD_USER"
  else
    mkdir -p "$SYSTEMD_USER"
    printf "%b\n" "Copying Service file"
    cp -rf "$CLONE_DIR/linux/kanata/kanata.service" "$SYSTEMD_USER"
  fi

  if [ -d "$KANATA_DIR" ]; then
    printf "%b\n" "Copying kanata config file"
    cp -rf "$CLONE_DIR/linux/kanata/config.kbd" "$KANATA_DIR"
  else
    mkdir -p "$KANATA_DIR" # Use the variable for consistency
    printf "%b\n" "Copying kanata config file"
    cp -rf "$CLONE_DIR/linux/kanata/config.kbd" "$KANATA_DIR"
  fi

  printf "%b\n" "** Enabling Services **"
  systemctl --user daemon-reload
  systemctl --user enable kanata.service
  systemctl --user start kanata.service
  systemctl --user status kanata.service # check whether the service is running

  printf "%b\n" "** Driver installation is done! Reboot the system to let kanata work properly. **"
  rm -rf "$CLONE_DIR"
}

# --- Rest of the instruction --- #
printf "%b\n" "***Welcome to Home Mod Row Keybinding setup***"
cloneRepo
setupKanata
