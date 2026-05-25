#!/usr/bin/env bash

cat <<'EOF'
 _____ _                 _   _         ___  _   _______ 
/  __ \ |               | | (_)       / _ \| | | | ___ \
| /  \/ |__   __ _  ___ | |_ _  ___  / /_\ \ | | | |_/ /
| |   | '_ \ / _` |/ _ \| __| |/ __| |  _  | | | |    / 
| \__/\ | | | (_| | (_) | |_| | (__  | | | | |_| | |\ \ 
 \____/_| |_|\__,_|\___/ \__|_|\___| \_| |_/\___/\_| \_|
                                                        
                                                        
EOF

printf "%b\n" "** Getting Chaotic AUR Primary Keys **"
ESCALATION_TOOL=$(command -v sudo || command -v doas)
$ESCALATION_TOOL pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
$ESCALATION_TOOL pacman-key --lsign-key 3056513887B78AEB

printf "%b\n" "** Installing Chaotic AUR mirrorlist **"
$ESCALATION_TOOL pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
$ESCALATION_TOOL pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

# -- Copying my pacman.conf -- ##
printf "%b\n" "** Backing up and updating /etc/pacman.conf **"
if [[ -f /etc/pacman.conf ]]; then
  $ESCALATION_TOOL cp /etc/pacman.conf /etc/pacman.conf.bak
fi

# We use 'tee' to handle root permissions for file writing
cat <<EOF | $ESCALATION_TOOL tee /etc/pacman.conf &>/dev/null
# See the pacman.conf(5) manpage for option and repository directives
# Paste this file in  /etc/

# This is a base options for pacman.conf

[options]
Color
ILoveCandy
VerbosePkgLists
HoldPkg = pacman glibc ly
Architecture = auto
CheckSpace
ParallelDownloads = 5

# By default, pacman accepts packages signed by keys that its local keyring
# trusts (see pacman-key and its man page), as well as unsigned packages.
SigLevel = Required DatabaseOptional
LocalFileSigLevel = Optional

# pacman searches repositories in the order defined here
[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist

[chaotic-aur]
Include = /etc/pacman.d/chaotic-mirrorlist

[multilib]
Include = /etc/pacman.d/mirrorlist
EOF
printf "%b\n" "** Refreshing mirrorlist **"
$ESCALATION_TOOL pacman -Syu

printf "%b\n" "*** Chaotic AUR setup is finished! ***"
