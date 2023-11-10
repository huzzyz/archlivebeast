#!/bin/bash
set -euo pipefail

# Define username for script usage
username=huzzyz # Change username here

# Remove entry from hosts file
sudo sed -i '/192.168.53.53 Solitude/d' /etc/hosts

# Refresh the network services
sudo systemctl restart dnsmasq

# Remove network share directories
sudo rm -rf /mnt/networkshares/{mystuff,Drive,Media,home,Software}

# Remove network shares from /etc/fstab
sudo sed -i '/# Network shares added by setup script/,+6d' /etc/fstab

# Remove systemd mount and automount units for network shares
shares=(
  "mystuff"
  "Drive"
  "Media"
  "home"
  "Software"
)
for share in "${shares[@]}"; do
  # Disable and stop the mount and automount units
  sudo systemctl disable mnt-networkshares-${share}.mount
  sudo systemctl disable mnt-networkshares-${share}.automount
  sudo systemctl stop mnt-networkshares-${share}.automount

  # Remove the mount and automount units
  sudo rm /etc/systemd/system/mnt-networkshares-${share}.mount
  sudo rm /etc/systemd/system/mnt-networkshares-${share}.automount
done

# Disable NetworkManager waits for the network to be online
sudo systemctl disable NetworkManager-wait-online.service

echo "System and user configuration reset complete."
