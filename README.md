# archlivebeast
Beast
Format Paritions (mkfs.fat -F32 /dev/sdXXX (for efi) mkfs.ext4 /dev/sdXXX (for ext4))
Mount Partitions
Install Base (pacstrap /mnt base linux linux-firmware git nano intel-ucode (or amd-ucode))
Create fstab enteries (genfstab -U /mnt >> /mnt/etc/fstab)
Move to Installtion (arch-chroot /mnt)
Create Swap ((dd if=/dev/zero of=/swapfile bs=1M count=1024 status=progress) chmod 600 /swapfile | mkswap /swapfile | swapon /swapfile)
Create entry in fstab (/swapfile none swap defaults 0 0)
Grab base files from git (make executable, edit as needed and run base.sh)
Add modules i915 and amdgpu to mkinticpio (/etc/mkinitcpio.conf) mkinitcpio -p linux
exit installer and unmount (umount -a)
login to created user
Maksure wifi is working execute nmtui
Clone from git again, make executable and run yaya.sh
Run apps.sh
Done.
