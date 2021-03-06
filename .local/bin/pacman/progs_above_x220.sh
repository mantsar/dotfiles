#!/bin/bash

# Required by some R packages
sudo pacman -S gcc-fortran unixodbc gnu-free-fonts

# Fixing libcurl-openssl-1.0 issue
# https://aur.archlinux.org/packages/libcurl-openssl-1.0
gpg --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 --recv 27EDEAF22F3ABCEB50DB9A125CC908FDB71E12C2
sudo pacman -Syy

yay -S neovide ttf-fira-code ttf-iosevka slack-desktop mongodb-bin mongodb-tools-bin rstudio-desktop-bin midivisualizer-git htslib # provides bgzip/tabix

# shiny-server-git
Rscript progs.R
