#!/bin/bash
set -euo pipefail

# Define username for script usage
username=huzzyz # Change username here

# Remove entry from hosts file
sudo sed -i '/192.168.53.53 Solitude/d' /etc/hosts

# Refresh the network services
#sudo systemctl restart NetworkManager

# Remove network share directories
sudo rm -rf /mnt/networkshares/{mystuff,Drive,Media,home,Software}

# Remove network shares from /etc/fstab
sudo sed -i '/# Network shares added by setup script/,+6d' /etc/fstab

# Remove automount for network shares
sudo sed -i '/\/mnt\/networkshares    \/etc\/auto.networkshares    --timeout=30/d' /etc/auto.master
sudo rm /etc/auto.networkshares

sudo systemctl disable autofs
sudo systemctl stop autofs

# Remove systemd service file for network shares
sudo rm /etc/systemd/system/network-shares.service

# Disable the network shares service
sudo systemctl disable network-shares.service

# Disable NetworkManager waits for the network to be online
sudo systemctl disable NetworkManager-wait-online.service

echo "System and user configuration reset complete."
