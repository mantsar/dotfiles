#!/bin/sh

sudo pacman -S glu # for improviz

yay -S vulkan-intel

yay -S bitwig-studio

# bluetooth for portable speakers
sudo pacman -S bluez blueman bluez-utils pulseaudio-bluetooth
