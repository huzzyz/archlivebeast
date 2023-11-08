#!/bin/bash
set -euo pipefail

# Install packages with yay
yay -S --noconfirm microsoft-edge-stable zsh-autocomplete-git zsh-syntax-highlighting-git zsh-autosuggestions-git kitty ttf-fira-code \
ttf-meslo-nerd-font-powerlevel10k zsh oh-my-zsh-git zsh-theme-powerlevel10k-git flatpak xdg-desktop-portal \
xdg-desktop-portal-kde timeshift timeshift-autosnap xorg-xhost kwin-bismuth-bin pdf-xchange qt6-wayland \
fastfetch autofs cifs-utils vlc flameshot packagekit-qt5 ocs-url pinta vdhcoapp-git enchant mythes-en \
ttf-liberation hunspell-en_US ttf-bitstream-vera pkgstats adobe-source-sans-pro-fonts gst-plugins-good \
ttf-droid ttf-dejavu aspell-en icedtea-web ttf-ubuntu-font-family ttf-anonymous-pro jre8-openjdk languagetool \
libmythes libreoffice-fresh normcap xdg-desktop-portal flameshot latte-dock-git kdeconnect freetube \
w3m-img imagemagick bluedevil bluez bluez-utils pfetch corectrl-git

# Install Flatpak application
flatpak install -y flathub tv.plex.PlexDesktop

echo "Package installation complete. Proceed with system and user configuration."
