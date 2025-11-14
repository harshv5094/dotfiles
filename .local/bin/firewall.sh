#!/usr/bin/env sh

have() { command -v "$1" >/dev/null 2>&1; }

# --- Detect escalation tool (sudo, doas, or root) ---
if [ "$(id -u)" -eq 0 ]; then
  ESCALATION_TOOL=""
elif have sudo; then
  ESCALATION_TOOL="sudo"
elif have doas; then
  ESCALATION_TOOL="doas"
else
  printf "%b\n" "No sudo/doas found, and not running as root. Exiting."
  exit 1
fi

# --- Detect package manager ---
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

# --- Install ufw ---
case "$package_manager" in
pacman)
  $ESCALATION_TOOL pacman -S --noconfirm --needed ufw
  ;;
apt)
  $ESCALATION_TOOL apt update
  $ESCALATION_TOOL apt install -y ufw
  ;;
dnf)
  $ESCALATION_TOOL dnf install -y ufw
  ;;
esac

# --- Configure ufw if installed ---
if have ufw; then
  printf "%b\n" "** Apply default firewall rules **"
  $ESCALATION_TOOL ufw limit 22/tcp
  $ESCALATION_TOOL ufw allow 80/tcp
  $ESCALATION_TOOL ufw allow 443/tcp
  $ESCALATION_TOOL ufw default deny incoming
  $ESCALATION_TOOL ufw default allow outgoing

  printf "%b\n" "** Enable ufw service **"
  $ESCALATION_TOOL ufw enable

  # Enable systemd service if available
  if have systemctl; then
    $ESCALATION_TOOL systemctl enable ufw
    $ESCALATION_TOOL systemctl start ufw
  fi
else
  printf "%b\n" "UFW installation failed or not found."
  exit 1
fi
