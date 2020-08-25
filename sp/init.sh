#!/bin/bash

# create realtime group
sudo groupadd realtime
sudo gpasswd -a $USER realtime
sudo gpasswd -a $USER audio

git clone https://github.com/tidalcycles/Dirt-Samples $HOME/sp/Dirt-Samples
git clone https://github.com/mantsar/synthdef $HOME/.config/SuperCollider/synthdef
cd $HOME/.config/SuperCollider/synthdef
git remote set-url origin ssh://git@github.com/mantsar/synthdef.git
# cd -
# ln -s $HOME/.local/share/SuperCollider/Extensions $HOME/.config/SuperCollider/Extensions # SCNvim automatically creates this
mkdir $HOME/.local/share/SuperCollider/Extensions/Faust
ln -s $HOME/.config/SuperCollider/synthdef/Main.sc $HOME/.local/share/SuperCollider/Extensions/Main.sc

mkdir $HOME/sp/projects
mkdir $HOME/sp/ardour
mkdir $HOME/sp/txt
mkdir $HOME/sp/tmp
mkdir $HOME/sp/songs
# script to create new folder for a new project where everything will work the same. then shorctuts to open projects with dmenu

# Uncheck box in Cadence gui PulseAdio bridge to not autostart
# In ALSA audio select ALSA -> PulseAudio > JACK bridge type

# Install SC quarks from startup.scd

# After install vim-tidal package run:
# cd $HOME/.config/nvim/pack/minpac/start/vim-tidal && sudo make install

# MISC

# If scnvim does not start properly call from within nvim
# :call scnvim#install()

# Change Font and theme to dracula in SCIDE

# Uncomment if needed
# /etc/pulse/client.cont
# autospawn = no
# ; autospawn = yes

# Fix ardour warning and real time scheduling if needed:
# https://wiki.debian.org/Ardour
# https://jackaudio.org/faq/linux_rt_config.html

# Tidal completion sources:
# https://tidalcycles.org/index.php/All_the_functions # copy into file then:
# https://github.com/tidalcycles/Tidal/blob/main/src/Sound/Tidal/Chords.hs#L113
# ...
