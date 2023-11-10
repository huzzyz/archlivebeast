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

# Set up automount for network shares
echo "/mnt/networkshares    /etc/auto.networkshares    --timeout=30" | sudo tee -a /etc/auto.master
cat > /etc/auto.networkshares <<EOF

# Network Shares
mystuff    -fstype=cifs,credentials=/home/${username}/.smbcred,uid=${username},gid=${username},iocharset=utf8,sec=ntlmssp,noperm,file_mode=0700,dir_mode=0700 ://Solitude/mystuff
Drive      -fstype=cifs,credentials=/home/${username}/.smbcred,uid=${username},gid=${username},iocharset=utf8,sec=ntlmssp,noperm,file_mode=0700,dir_mode=0700 ://Solitude/Drive
Media      -fstype=cifs,credentials=/home/${username}/.smbcred,uid=${username},gid=${username},iocharset=utf8,sec=ntlmssp,noperm,file_mode=0700,dir_mode=0700 ://Solitude/data
home       -fstype=cifs,credentials=/home/${username}/.smbcred,uid=${username},gid=${username},iocharset=utf8,sec=ntlmssp,noperm,file_mode=0700,dir_mode=0700 ://Solitude/home
Software   -fstype=cifs,credentials=/home/${username}/.smbcred,uid=${username},gid=${username},iocharset=utf8,sec=ntlmssp,noperm,file_mode=0700,dir_mode=0700 ://Solitude/Software
EOF

sudo systemctl enable autofs
sudo systemctl start autofs

# Create systemd service file for network shares
cat > /etc/systemd/system/network-shares.service <<EOF
[Unit]
Description=Mount Network Shares
Wants=network-online.target
After=network-online.target
RequiresMountsFor=/mnt/networkshares

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'sleep 10 && /usr/bin/mount -a -t cifs'
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the network shares service
sudo systemctl enable network-shares.service
sudo systemctl start network-shares.service

# Ensure NetworkManager waits for the network to be online
sudo systemctl enable NetworkManager-wait-online.service

echo "System and user configuration complete."
