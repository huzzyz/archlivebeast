![alt text](https://img.shields.io/badge/Arch_Linux-1793D1?style=for-the-badge&logo=arch-linux&logoColor=black)
![alt text](https://img.shields.io/badge/Shell_Script-121011?style=for-the-badge&logo=gnu-bash&logoColor=black) 

# archlivebeast
Since we have the archinstall script doing most of the legwork. I've resorted to creating just ~~a custom script that installs all the packages and creates the proper entries for network shares and modifying the hosts~~ 4 main scripts now.

###### - Part 1: initial_setup.sh - Update keyring, install yay, set up reflector.  
###### - Part 2: install_packages.sh - Install all required packages.  
###### - Part 3: configure_system.sh - Configure user, system, network, .zshrc, and fstab.  
###### - Part 4: configure_my_kde.sh - Few settings I always do when I have a fresh KDE install.  

I initially began with Ansible, leveraging recent experience from a project where I developed a custom Debian installer for an application. However, as I delved deeper into the work, I found a growing preference for using bash directly. While the option to craft individual playbooks in Ansible remains on the table—and it's something I might consider for future endeavors—at present, I've decided to proceed with bash for this task.
