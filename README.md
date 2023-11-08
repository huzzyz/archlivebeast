# archlivebeast
Since we have the archinstall script doing most of the legwork. I've resorted to creating just ~~a custom script that installs all the packages and creates the proper entries for network shares and modifying the hosts~~ 4 main scripts now.

Part 1: initial_setup.sh - Update keyring, install yay, set up reflector.
Part 2: install_packages.sh - Install all required packages.
Part 3: configure_system.sh - Configure user, system, network, .zshrc, and fstab.
Part 4: configure_my_kde.sh - Few settings I always do when I have a fresh KDE install.

Initially I thought i'd try my hand with ansible since I've played around with it recently for a project for creating a custom debian installer for an application but the more I started working on it. I realized I preferred doing it in bash itself. Yes I could possibly create individual playbooks, perhaps I might in the future for now this is where we are at.
