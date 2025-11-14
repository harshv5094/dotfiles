#!/usr/bin/env sh

####################
# Global Directory #
####################
SYSTEMD_USER="$HOME/.config/systemd/user/"
CLONE_DIR="$HOME/projects/personal/home-row-mods/"
KANATA_DIR="$HOME/.config/kanata"

if [ ! -d "$CLONE_DIR" ]; then
  printf "%b\n" "${CLONE_DIR} directory doesn't exist. Clonning directory"

  if [ ! -d "$HOME/projects/personal/" ]; then
    mkdir -p "$HOME/projects/personal/"
    git clone --depth 1 https://github.com/harshv5094/home-row-mods "$HOME/projects/personal"
  else
    git clone --depth 1 https://github.com/harshv5094/home-row-mods "$HOME/projects/personal"
  fi
fi

#####################
# TUI color Message #
#####################
color_msg() {
  color="$1"
  shift
  case "$color" in
  cyan) tput setaf 6 ;;   # Cyan
  yellow) tput setaf 3 ;; # Yellow
  green) tput setaf 2 ;;  # Green
  red) tput setaf 1 ;;    # Red
  reset) tput sgr0 ;;     # Reset color
  esac
  echo "$@"
  tput sgr0 # Reset color
}

################################
# Last Command Execution Check #
################################
cmdCheck() {
  if [ "$1" -eq 0 ]; then
    color_msg green "Success!"
  else
    color_msg red "Failed!"
  fi
}

#############################
# Command Existence Checker #
#############################
have() {
  command -v "$1" >/dev/null 2>&1
}

cloneRepo() {
  if [ ! -d "$CLONE_DIR" ]; then
    color_msg cyan "Cloning my dotfiles repository..."
    git clone https://github.com/harshv5094/home-row-mods "$CLONE_DIR"
    cmdCheck "$?"
  fi
}

main() {
  color_msg cyan "***Welcome to Home Mod Row Keybinding setup***"

  # NOTE: Installing Kanata Package
  if have paru; then
    color_msg yellow "**Installing kanata-bin from paru**"
    paru -S --noconfirm kanata-bin
  else
    color_msg red "**Please install paru aur helper first**"
    return
  fi

  # NOTE: Creating `uinput` and `input` group
  color_msg yellow "Creating group uinput and input "
  # List of groups to check
  for group in uinput input; do
    if getent group "$group" >/dev/null; then
      echo "Group '$group' exists. Deleting the group and recreating it"
      sudo groupdel $group
      sudo groupadd --system $group
      cmdCheck "$?"
    else
      echo "Group '$group' does not exist."
      sudo groupadd --system $group
      cmdCheck "$?"
    fi
  done

  # NOTE: Adding $USER to `uinput` and `input`
  color_msg yellow "Adding group uinput and input to user $USER "
  sudo usermod -aG uinput "$USER"
  cmdCheck "$?"
  sudo usermod -aG input "$USER"
  cmdCheck "$?"

  color_msg yellow "Copying rules file"
  sudo cp -rf "$CLONE_DIR/linux/kanata/99-input.rules" /etc/udev/rules.d/
  cmdCheck "$?"

  color_msg yellow "Reloading Rules"
  sudo udevadm control --reload-rules && sudo udevadm trigger
  cmdCheck "$?"

  color_msg yellow "Verifying uinput file"
  ls -l /dev/uinput
  cmdCheck "$?"

  color_msg yellow "Loading uinput drivers"
  sudo modprobe uinput
  cmdCheck "$?"

  if [ -d "$SYSTEMD_USER" ]; then
    color_msg yellow "Copying Service file"
    cp -rf "$CLONE_DIR/linux/kanata/kanata.service" "$SYSTEMD_USER"
    cmdCheck "$?"
  else
    mkdir -p "$SYSTEMD_USER"
    color_msg yellow "Copying Service file"
    cp -rf "$CLONE_DIR/linux/kanata/kanata.service" "$SYSTEMD_USER"
    cmdCheck "$?"
  fi

  if [ -d "$KANATA_DIR" ]; then
    color_msg yellow "Copying kanata file"
    cp -rf "$CLONE_DIR/linux/kanata/config.kbd" "$KANATA_DIR"
    cmdCheck "$?"
  else
    mkdir -p "$HOME/.config/kanata"
    color_msg yellow "Copying kanata file"
    cp -rf "$CLONE_DIR/linux/kanata/config.kbd" "$KANATA_DIR"
    cmdCheck "$?"
  fi

  color_msg yellow "** Enabling Services **"
  systemctl --user daemon-reload
  systemctl --user enable kanata.service
  systemctl --user start kanata.service
  systemctl --user status kanata.service # check whether the service is running
  cmdCheck "$?"

  color_msg yellow "** Driver installation is done! Reboot the system to let kanata work properly. **"
}

cloneRepo
main
