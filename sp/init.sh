#!/bin/bash

# create realtime group
sudo groupadd realtime
sudo gpasswd -a $USER realtime
sudo gpasswd -a $USER audio

git clone https://github.com/TylerMclaughlin/midi_to_tidalcycles $HOME/sp/midi_to_tidalcycles
git clone https://github.com/tidalcycles/Dirt-Samples $HOME/sp/Dirt-Samples
git clone https://github.com/mantsar/synthdef $HOME/.config/SuperCollider/synthdef
cd $HOME/.config/SuperCollider/synthdef
git remote set-url origin ssh://git@github.com/mantsar/synthdef.git
# cd -
# ln -s $HOME/.local/share/SuperCollider/Extensions $HOME/.config/SuperCollider/Extensions # SCNvim automatically creates this
mkdir -p $HOME/.local/share/SuperCollider/Extensions/Faust
ln -s $HOME/.config/SuperCollider/synthdef/Main.sc $HOME/.local/share/SuperCollider/Extensions/Main.sc

mkdir $HOME/sp/projects
mkdir $HOME/sp/ardour
mkdir $HOME/sp/txt
mkdir $HOME/sp/tmp
mkdir $HOME/sp/songs
mkdir $HOME/sp/samples
mkdir $HOME/sp/plugins
mkdir $HOME/sp/orca

# mi-UGens
makepkg -si $HOME/pkgbuilds/mi-UGens

# midi to tidal script
# https://github.com/TylerMclaughlin/midi_to_tidalcycles
sudo pacman -S python2-numpy python2-setuptools swig
git clone https://github.com/vishnubob/python-midi $HOME/sp/tmp
cd $HOME/sp/tmp/python-midi
python2 setup.py install --user --prefix=

# vcv rack
# mkdir ~/sp/vcvrack
# cd ~/sp/vcvrack
# wget https://vcvrack.com/downloads/Rack-1.1.6-lin.zip
# rm Rack-1.1.6-lin.zip

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
# ardour preferences:
# Edit preferences -> MIDI -> Audition -> check Sound MIDI notes as they are selected in the editor
# Session proterties -> Misc -> MIDI region copies are independent -> Use these settings as default
# View -> Show editor mixer

# Tidal completion sources:
# https://tidalcycles.org/index.php/All_the_functions # copy into file then:
# https://github.com/tidalcycles/Tidal/blob/main/src/Sound/Tidal/Chords.hs#L113
# ...

# Carla: add sp/plugins for lv2. Change default project dir to sp/carla

# get latest lsp-plugins release
# https://github.com/sadko4u/lsp-plugins/releases
# wget https://github.com/sadko4u/lsp-plugins/releases/download/1.1.28/lsp-plugins-lv2-1.1.28-Linux-x86_64.tar.gz sp/plugins
# mv last dir containing plugins to sp/plugins/dir  . Otherwise it does not find required .tll files

# bitwig
# uncheck in cadence ALSA MIDI -> start with jack (otherwise external midi controllers cant connect)
# bitwig support for launchpad mk3 https://github.com/git-moss/DrivenByMoss-Documentation/blob/master/Installation.md
# run bitwig_midi script and launch alsa jack midi bridge (in cadence) for midi routing to work in bitwig
# use carla to load patchbay templates
