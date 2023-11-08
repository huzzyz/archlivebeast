#!/bin/bash
set -euo pipefail

# Update system and keyring
sudo pacman -Syyu --noconfirm
sudo pacman -Sy --needed --noconfirm archlinux-keyring

# Install Yay helper for AUR
git clone https://aur.archlinux.org/yay.git /tmp/yay
(cd /tmp/yay && makepkg -si --noconfirm)
rm -rf /tmp/yay

# Set up the fastest mirrors for Iran
sudo pacman -S --needed --noconfirm reflector
sudo reflector -f 15 --country 'Iran' --protocol https --sort rate --save /etc/pacman.d/mirrorlist
sudo systemctl enable reflector.timer

echo "Initial setup complete. Proceed with package installation."
