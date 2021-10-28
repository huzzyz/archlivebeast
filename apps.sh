#!/bin/bash
app_list="xorg sddm plasma breeze-gtk kdeconnect kde-gtk-config khotkeys kinfocenter kinit kio-fuse konsole kscreen okular plasma-desktop
plasma-disks plasma-nm plasma-pa powerdevil print-manager sddm-kcm solid xsettingsd google-chrome teamviewer discover smplayer smplayer-themes
bleachbit nasc ncdu discord conky conky-manager flameshot python-pip otpclient ksysguard notion-app-enhanced masterpdfeditor-free 
stacer-bin teamviewer backintime tesseract tesseract-data-eng leptonica xdotool libinput-gestures plasma-browser-integration 
nemo nemo-fileroller nemo-preview nemo-share wget gthumb gedit packagekit-qt5 corectrl fish pkgfile ttf-dejavu powerline-fonts ttf-ms-win11"

yay -Syyu $app_list --noconfirm


echo 'PATH="$PATH:/$HOME/.local/bin"' >> ~/.bashrc
source ~/.bashrc

echo '''
[Wallet]                   
Enabled=false              
''' | tee -a ~/.config/kwalletrc
pip install normcap
systemctl enable sddm
