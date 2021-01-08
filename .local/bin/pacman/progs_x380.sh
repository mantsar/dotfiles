#!/bin/bash

sudo pacman -S vulkan-intel

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
