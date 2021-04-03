#!/bin/sh

# Orca-c
# # https://git.sr.ht/~rabbits/orca
# sudo pacman -S ncurses portmidi
# git clone https://github.com/hundredrabbits/Orca-c.git ~/tmp/Orca-c
# cd ~/tmp/Orca-c
# make          # Compile orca
# cp build/orca ~/.local/bin/orca   # Executable

# Orca electron
# git clone https://github.com/hundredrabbits/Orca.git ~/sp/orca/Orca
# with abelton-link support
rm -r $HOME/sp/orca/Orca
git clone https://github.com/mcartagenah/Orca ~/sp/orca/Orca
cd ~/sp/orca/Orca/desktop
npm install
# npm start
