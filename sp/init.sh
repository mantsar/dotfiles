#!/bin/bash

git clone https://github.com/tidalcycles/Dirt-Samples

mkdir ardour

gpasswd -a $USER realtime
gpasswd -a $USER audio

# Select in cadence gui to spawn on autologin and remove spawning for pulse
/etc/pulse/client.cont
# uncomment
autospawn = no
; autospawn = yes

# Fix ardour warning and real time scheduling:
# https://wiki.debian.org/Ardour
# https://jackaudio.org/faq/linux_rt_config.html

# Tidal completion sources:
# https://tidalcycles.org/index.php/All_the_functions # copy into file then:
# https://github.com/tidalcycles/Tidal/blob/main/src/Sound/Tidal/Chords.hs#L113
