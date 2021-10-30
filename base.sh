#!/bin/bash

ln -sf /usr/share/zoneinfo/Asia/Dubai /etc/localtime
hwclock --systohc
sed -i '160s/.//' /etc/locale.gen
locale-gen
echo "LANG=en_GB.UTF-8" >> /etc/locale.conf
echo "beast" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 beast.localdomain beast" >> /etc/hosts
echo "192.168.1.53 Solitude" >> /etc/hosts  
echo root:change-me | chpasswd #change password
pacman -S grub efibootmgr networkmanager network-manager-applet broadcom-wl wget dialog wpa_supplicant mtools dosfstools base-devel linux-headers avahi xdg-user-dirs xdg-utils nfs-utils inetutils dnsutils bluez bluez-utils cups hplip alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack bash-completion openssh rsync acpi acpi_call virt-manager qemu qemu-arch-extra edk2-ovmf bridge-utils dnsmasq vde2 openbsd-netcat iptables-nft ipset flatpak nss-mdns acpid os-prober ntfs-3g terminus-font
pacman -S --noconfirm xf86-video-amdgpu
pacman -S --noconfirm xf86-video-intel
#pacman -S --noconfirm nvidia nvidia-utils nvidia-settings

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable cronie
systemctl enable bluetooth
systemctl enable cups.service
systemctl enable cronie.service
systemctl enable sshd
systemctl enable avahi-daemon
#systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
systemctl enable libvirtd
systemctl enable acpid

useradd -m huzzyz
echo huzzyz:change-me | chpasswd #change password
usermod -aG libvirt huzzyz

echo "huzzyz ALL=(ALL) ALL" >> /etc/sudoers.d/huzzyz


printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"

#credits to eflinux; without whom i wouldn't have done half the things

