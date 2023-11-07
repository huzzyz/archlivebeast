#!/usr/bin/env bash
set -euo pipefail

# Define username for script usage
username=$(whoami)

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

# Install packages
yay -S --noconfirm zsh-autocomplete-git zsh-syntax-highlighting-git zsh-autosuggestions-git kitty ttf-fira-code \
ttf-meslo-nerd-font-powerlevel10k zsh oh-my-zsh-git zsh-theme-powerlevel10k-git flatpak xdg-desktop-portal \
xdg-desktop-portal-kde timeshift timeshift-autosnap xorg-xhost kwin-bismuth-bin pdf-xchange qt6-wayland \
fastfetch autofs cifs-utils vlc flameshot packagekit-qt5 ocs-url pinta vdhcoapp-git enchant mythes-en \
ttf-liberation hunspell-en_US ttf-bitstream-vera pkgstats adobe-source-sans-pro-fonts gst-plugins-good \
ttf-droid ttf-dejavu aspell-en icedtea-web ttf-ubuntu-font-family ttf-anonymous-pro jre8-openjdk languagetool \
libmythes libreoffice-fresh normcap xdg-desktop-portal flameshot latte-dock-git kdeconnect freetube \
w3m-img imagemagick bluedevil bluez bluez-utils pfetch

# Set up KWin shortcuts and reconfigure
kwriteconfig5 --file kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.krunner,/App,,toggleDisplay"
qdbus org.kde.KWin /KWin reconfigure

# Create Kitty config
mkdir -p ~/.config/kitty
cat > ~/.config/kitty/kitty.conf <<EOF
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
mkdir -p ~/.config
cat > ~/.config/kwalletrc <<EOF
[Wallet]
Enabled=false
EOF

# Enable and start Bluetooth services
sudo systemctl enable --now bluetooth

# Create network share directories
sudo mkdir -p /mnt/networkshares/{mystuff,Drive,Media,home,Software}

# Add network shares to /etc/fstab and create a hosts entry for Solitude
echo "192.168.53.53 Solitude" | sudo tee -a /etc/hosts

# Ensure we do not overwrite /etc/fstab but add a significant space for clarity
{
  echo ""
  echo "# Network shares added by setup script"
  echo "//Solitude/mystuff /mnt/networkshares/mystuff cifs credentials=/home/${username}/.smbcred,uid=${username},gid=${username},iocharset=utf8,sec=ntlmssp,noperm,x-gvfs-name=mystuff,file_mode=0700,dir_mode=0700,_netdev 0 0"
  echo "//Solitude/Drive /mnt/networkshares/Drive cifs credentials=/home/${username}/.smbcred,uid=${username},gid=${username},iocharset=utf8,sec=ntlmssp,noperm,x-gvfs-name=drive,file_mode=0700,dir_mode=0700,_netdev 0 0"
  echo "//Solitude/data /mnt/networkshares/Media cifs credentials=/home/${username}/.smbcred,uid=${username},gid=${username},iocharset=utf8,sec=ntlmssp,noperm,x-gvfs-name=media,file_mode=0700,dir_mode=0700,_netdev 0 0"
  echo "//Solitude/home /mnt/networkshares/home cifs credentials=/home/${username}/.smbcred,uid=${username},gid=${username},iocharset=utf8,sec=ntlmssp,noperm,x-gvfs-name=home,file_mode=0700,dir_mode=0700,_netdev 0 0"
  echo "//Solitude/Software /mnt/networkshares/Software cifs credentials=/home/${username}/.smbcred,uid=${username},gid=${username},iocharset=utf8,sec=ntlmssp,noperm,x-gvfs-name=software,file_mode=0700,dir_mode=0700,_netdev 0 0"
} | sudo tee -a /etc/fstab

# Set up automount for network shares
echo "/mnt/networkshares    /etc/auto.networkshares    --timeout=30" | sudo tee -a /etc/auto.master
sudo systemctl start autofs
sudo systemctl enable autofs

# Create and populate /etc/auto.networkshares
cat > /etc/auto.networkshares <<EOF
# Network Shares
mystuff    -fstype=cifs,credentials=/home/${username}/.smbcred,uid=${username},gid=${username},iocharset=utf8,sec=ntlmssp,noperm,file_mode=0700,dir_mode=0700 ://Solitude/mystuff
Drive      -fstype=cifs,credentials=/home/${username}/.smbcred,uid=${username},gid=${username},iocharset=utf8,sec=ntlmssp,noperm,file_mode=0700,dir_mode=0700 ://Solitude/Drive
Media      -fstype=cifs,credentials=/home/${username}/.smbcred,uid=${username},gid=${username},iocharset=utf8,sec=ntlmssp,noperm,file_mode=0700,dir_mode=0700 ://Solitude/data
home       -fstype=cifs,credentials=/home/${username}/.smbcred,uid=${username},gid=${username},iocharset=utf8,sec=ntlmssp,noperm,file_mode=0700,dir_mode=0700 ://Solitude/home
Software   -fstype=cifs,credentials=/home/${username}/.smbcred,uid=${username},gid=${username},iocharset=utf8,sec=ntlmssp,noperm,file_mode=0700,dir_mode=0700 ://Solitude/Software
EOF

# Install Flatpak application
flatpak install -y flathub tv.plex.PlexDesktop

# Update ZSH configuration
cat >> ~/.zshrc <<'EOF'
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#fi

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Home
bindkey '\e[H'  beginning-of-line
bindkey '\eOH'  beginning-of-line
# End
bindkey '\e[F'  end-of-line
bindkey '\eOF'  end-of-line
# Delete
bindkey '\e[3~' delete-char
# Backspace
bindkey '\e?' backward-delete-char

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=1000
setopt SHARE_HISTORY

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
pfetch
EOF

# Finish with setting default shell to ZSH
if [[ $SHELL != */zsh ]]; then
  chsh -s $(which zsh) $username
  echo "Default shell changed to ZSH. Please logout and login again for this to take effect."
fi

echo "Setup complete! Please review any manual steps required."
