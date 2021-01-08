#!/bin/bash

# enable multilib repo
sudo pacman -S steam discord lutris

sudo pacman -S wine-staging giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader

# add lutris games to steam
# https://github.com/lutris/lutris/wiki
# install proton from within steam
# Remove Steam ads > setting > interface > uncheck "Notify me about additions or changes to my games..."
# Shader Pre-Caching > check "Allow background processing of Vulkan shaders"
# Launch steam in library by default:
# Settings > interface > select which Steam window appears when program starts > library

# Bluetooth support
sudo pacman -S bluez bluez-utils bluemoon # pulseaudio-bluetooth

# For headphones
# https://wiki.archlinux.org/index.php/bluetooth_headset

# For LDAC codec support
# https://wiki.archlinux.org/index.php/bluetooth_headset#LDAC/aptX
yay -S pulseaudio-modules-bt libldac bitwig-studio

sudo pacman -S abletonlink

# MANUALLY
# Instructions to set up Bluetooth: https://wiki.archlinux.org/index.php/Bluetooth
# MX Anywhere 2s
# https://askubuntu.com/questions/763509/logitech-mx-master-wireless-mouse-under-ubuntu-14-04
# bluetoothctl
# [bluetooth]# power off
# [bluetooth]# power on
# [bluetooth]# scan on
# [bluetooth]# connect XX:XX:XX:XX:XX:XX
# [Arc Touch Mouse SE]# trust
# [Arc Touch Mouse SE]# connect XX:XX:XX:XX:XX:XX
# [Arc Touch Mouse SE]# pair
# [Arc Touch Mouse SE]# unblock
# [Arc Touch Mouse SE]# power off
# [bluetooth]# power on

# Start bluetooth automatically when tray is opened
# gsettings set org.blueman.plugins.powermanager auto-power-on true
# Make bluetooth permanent for a session
# adapter > always visible
