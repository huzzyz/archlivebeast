#!/bin/bash
set -euo pipefail

# Define username for script usage
username=huzzyz # Change username here

# Add entry to hosts file
echo "192.168.53.53 Solitude" | sudo tee -a /etc/hosts

# Refresh the network services
sudo systemctl restart dnsmasq

# Create network share directories
sudo mkdir -p /mnt/networkshares/{mystuff,Drive,Media,home,Software}

# Add network shares to /etc/fstab
echo "# Network shares added by setup script" | sudo tee -a /etc/fstab
shares=(
  "mystuff"
  "Drive"
  "Media"
  "home"
  "Software"
)
for share in "${shares[@]}"; do
  echo "//Solitude/${share} /mnt/networkshares/${share} cifs credentials=/home/${username}/.smbcred,uid=${username},gid=${username},iocharset=utf8,sec=ntlmssp,noperm,x-gvfs-name=${share},file_mode=0700,dir_mode=0700,_netdev 0 0" | sudo tee -a /etc/fstab
done

# Create systemd mount and automount units for network shares
for share in "${shares[@]}"; do
  cat > /etc/systemd/system/mnt-networkshares-${share}.mount <<EOF
[Unit]
Description=Mount ${share} Network Share
Requires=network-online.target
After=network-online.target

[Mount]
What=//Solitude/${share}
Where=/mnt/networkshares/${share}
Type=cifs
Options=credentials=/home/${username}/.smbcred,uid=${username},gid=${username},iocharset=utf8,sec=ntlmssp,noperm,x-gvfs-name=${share},file_mode=0700,dir_mode=0700,_netdev

[Install]
WantedBy=multi-user.target
EOF

  cat > /etc/systemd/system/mnt-networkshares-${share}.automount <<EOF
[Unit]
Description=Automount ${share} Network Share
Requires=network-online.target
After=network-online.target

[Automount]
Where=/mnt/networkshares/${share}
TimeoutIdleSec=10

[Install]
WantedBy=multi-user.target
EOF

  # Enable and start the mount and automount units
  sudo systemctl enable mnt-networkshares-${share}.mount
  sudo systemctl enable mnt-networkshares-${share}.automount
  sudo systemctl start mnt-networkshares-${share}.automount
done

# Ensure NetworkManager waits for the network to be online
sudo systemctl enable NetworkManager-wait-online.service

echo "System and user configuration complete."
