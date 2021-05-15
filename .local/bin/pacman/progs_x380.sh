#!/bin/bash

sudo pacman -S vulkan-intel

sudo pacman -S virtualbox virtualbox-host-modules-arch virtualbox-guest-iso

# For tablet
# https://wiki.archlinux.org/index.php/Tablet_PC
sudo pacman -S gnome xf86-input-wacom onboard iio-sensor-proxy

# Bluetooth support
# https://wiki.archlinux.org/index.php/Bluetooth#Device_does_not_show_up_in_scan
sudo pacman -S bluez blueman # pulseaudio-bluetooth # bluez-utils

yay -S bluez-utils-compat

# For headphones
# https://wiki.archlinux.org/index.php/bluetooth_headset

# For LDAC codec support
# https://wiki.archlinux.org/index.php/bluetooth_headset#LDAC/aptX
yay -S pulseaudio-modules-bt libldac bitwig-studio

sudo pacman -S abletonlink

# For midi logging
# https://freesoftwaremusic.wordpress.com/2015/03/29/midi-monitors/comment-page-1/
yay -S mididings-git

# MANUALLY
# onboard-settings to change on screen keyboard looks

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

# Gnome
# display settings scale -> 200%
# add/remove favorites application in Activities
# use Night Light instead of redshift
