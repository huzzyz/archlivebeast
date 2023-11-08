#!/bin/bash
set -euo pipefail

# Get the current user
username="$(whoami)"
config_path="/home/$username/.config"

# Enable NumLock on KDE startup
kwriteconfig5 --file "${config_path}/ksmserverrc" --group 'General' --key 'NumLock' 'On'

# Set KDE to start with a new session
kwriteconfig5 --file "${config_path}/ksmserverrc" --group 'General' --key 'loginMode' 'default'

# Change KWin fullscreen shortcut to Meta+Up
kwriteconfig5 --file "${config_path}/kglobalshortcutsrc" --group 'kwin' \
              --key 'ShowDesktopGrid' 'Meta+Up,Meta+Up,Show Desktop Grid'

# Add shortcut for Kitty - Meta+T
kwriteconfig5 --file "${config_path}/kglobalshortcutsrc" --group 'kitty' \
              --key '_launch' 'Meta+T,none,Launch Kitty'

# Add shortcut for Microsoft Edge - Meta+B
kwriteconfig5 --file "${config_path}/kglobalshortcutsrc" --group 'Microsoft Edge' \
              --key '_launch' 'Meta+B,none,Launch Microsoft Edge'

# Enable touchpad tap to click and two-finger tap for right-click, three-finger tap for middle-click
kwriteconfig5 --file "${config_path}/touchpadrc" --group 'General' --key 'TapButton1' '1'
kwriteconfig5 --file "${config_path}/touchpadrc" --group 'General' --key 'TapButton2' '3'
kwriteconfig5 --file "${config_path}/touchpadrc" --group 'General' --key 'TapButton3' '2'

# Apply changes to system shortcuts
qdbus org.kde.kglobalaccel /kglobalaccel reconfigure

# Apply KWin changes
qdbus org.kde.KWin /KWin reconfigure

echo "KDE configuration complete."
