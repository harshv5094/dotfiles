#!/usr/bin/env sh

if command -v pacman >/dev/null; then
  # Installing my nvidia drivers
  printf "%b\n" "** Installing Nvidia Drivers **"
  sudo pacman -S nvidia-dkms nvidia-utils egl-wayland opencl-nvidia nvidia-settings linux-headers linux-lts-headers xorg

  # Enable Systemd Services
  sudo systemctl enable nvidia-hibernate nvidia-powerd nvidia-persistenced nvidia-resume nvidia-suspend

  printf "%b\n" "** Creating Initial Ramdisk Environment **"
  mkinitcpio
fi
