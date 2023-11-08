#!/bin/bash
set -euo pipefail

# Define username for script usage
username=$(whoami)

# Create Kitty config
mkdir -p "/home/${username}/.config/kitty"
cat > "/home/${username}/.config/kitty/kitty.conf" <<EOF
font_family      FiraCode Nerd Font Reg
bold_font        auto
italic_font      auto
bold_italic_font auto
cursor_shape block
scrollback_lines 2000
detect_urls yes
open_url_with default
show_hyperlink_targets no
copy_on_select yes
enable_audio_bell no
background_opacity 0.8
EOF

# Disable KWallet
mkdir -p "/home/${username}/.config"
cat > "/home/${username}/.config/kwalletrc" <<EOF
[Wallet]
Enabled=false
EOF

# Enable and start Bluetooth services
sudo systemctl enable --now bluetooth

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

# Add entry to hosts file
echo "192.168.53.53 Solitude" | sudo tee -a /etc/hosts

# Create systemd service file for network shares
cat > /etc/systemd/system/network-shares.service <<EOF
[Unit]
Description=Mount Network Shares
Wants=network-online.target
After=network-online.target
RequiresMountsFor=/mnt/networkshares

[Service]
Type=oneshot
ExecStart=/usr/bin/mount -a -t cifs
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

# Enable and start the network shares service
sudo systemctl enable network-shares.service
sudo systemctl start network-shares.service

# Ensure NetworkManager waits for the network to be online
sudo systemctl enable NetworkManager-wait-online.service

# Update ZSH configuration
cat >> "/home/${username}/.zshrc" <<'EOF'
# ZSH configuration added by setup script
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Keybindings
bindkey '\e[H'  beginning-of-line
bindkey '\eOH'  beginning-of-line
bindkey '\e[F'  end-of-line
bindkey '\eOF'  end-of-line
bindkey '\e[3~' delete-char
bindkey '\e?' backward-delete-char

# History settings
HISTFILE=/home/${username}/.zsh_history
HISTSIZE=10000
SAVEHIST=1000
setopt SHARE_HISTORY

# Powerlevel10k prompt
[[ ! -f /home/${username}/.p10k.zsh ]] || source /home/${username}/.p10k.zsh
EOF

# Change the owner of the home directory contents to the user
sudo chown -R ${username}:${username} "/home/${username}/"

# Set default shell to ZSH if not already set
if [[ $SHELL != */zsh ]]; then
  sudo chsh -s $(which zsh) "${username}"
fi

echo "System and user configuration complete."
