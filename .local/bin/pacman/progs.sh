#!/usr/bin/bash

sudo pacman -S zsh zsh-autosuggestions openfortivpn mpv ranger atool atom ardour alsa-utils acpi zsh-completions zathura zathura-djvu zathura-pdf-mupdf youtube-dl xorg-xprop xorg-server wget unzip unrar ueberzug tree tmux tldr supercollider sc3-plugins rsync r qutebrowser python-adblock ctags docker docker-compose dunst faust ffmpeg foxdot fzf git gnustep-base gnustep-make cmake haskell-tidal i3-gaps i3blocks ipython jack2 japa libnotify libreoffice-still lsof luarocks lv2 neofetch nginx pandoc pandoc-citeproc pulseaudio pulseaudio-alsa pulseaudio-jack pavucontrol python-i3ipc python-pynvim python-pywal ripgrep ttf-ubuntu-font-family unclutter scrot redshift termite sxiv feh picom networkmanager pulsemixer xdotool rofi mpc mpd ncmpcpp transmission-cli transmission-gtk pass syncthing pd xclip npm python-dbus xorg-xinit ttf-nerd-fonts-symbols-mono ttf-linux-libertine ttf-joypixels xorg-xwininfo dmenu python-tldextract python-pip cadence python-pyperclip ttf-dejavu firefox firefox-ublock-origin firefox-extension-https-everywhere firefox-dark-reader firefox-tridactyl man-db evince a2jmidid glava ttf-font-awesome alacritty pcmanfm-gtk3 breeze-grub acpilight sshfs bash-language-server shellcheck python-language-server python-gobject htop screenkey ruby mixxx carla sonic-pi network-manager-applet python-adblock abletonlink

mkdir $HOME/Downloads $HOME/tmp $HOME/Videos $HOME/Pictures

# install yay package and https://github.com/mantsar/pkgbuilds cadence-claudia
git clone https://www.github.com/mantsar/pkgbuilds.git $HOME/pkgbuilds
cd $HOME/pkgbuilds
git remote set-url origin ssh://git@github.com/mantsar/pkgbuilds.git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

yay -S neovim-git zsh-plugin-wd-git zsh-fast-syntax-highlighting-git navi pyradio-git faustlive-git xcwd-git nerd-fonts-hack i3-layout-manager-git flashfocus-git
yay -S supercollider-mkplugins supercollider-f0plugins supercollider-maths-git
yay -S supercollider-vstplugin
yay -S jack-matchmaker

# haskell-language-server-bin
# arduino
# arduino-docs
# ladish python2-distutils-extra

apm install atom-hydra vim-mode-plus vim-mode-clipboard-plus ex-mode 

git clone https://github.com/k-takata/minpac.git ~/.config/nvim/pack/minpac/opt/minpac

git config --global user.email "sarauskas.mantas@gmail.com"
git config --global user.name Mantas

git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
# echo "default_linemode devicons" >> $HOME/.config/ranger/rc.conf

chsh -s /usr/bin/zsh
# source $HOME/.zshrc

mkdir $HOME/.cache/zsh && touch $HOME/.cache/zsh/history

/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME remote set-url origin ssh://git@github.com/mantsar/dotfiles.git
/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME config --local status.showUntrackedFiles no

# MPD
mkdir $HOME/.config/mpd/playlists
touch $HOME/.config/mpd/db

# i3
pip3 install --user i3-workspace-names-daemon click oscpy psutil # for sonic-pi-tool

# tmux
git clone https://github.com/tmux-plugins/tmux-resurrect $HOME/pkgbuilds/tmux-resurrect

# MANUALLY -------------------------

# /etc/default/grub
# GRUB_THEME="/usr/share/grub/themes/breeze/theme.txt"
# sudo grub-mkconfig -o /boot/grub/grub.cfg

# IF NOT EXTERNAL MONITOR
# https://wiki.archlinux.org/index.php/Backlight
# sudo gpasswd -a $USER video
# /etc/udev/rules.d/backlight.rules
# ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="acpi_video0", RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness"
# ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="acpi_video0", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"

# reboot

# Syncthing
# http://127.0.0.1:8384
# Delete default dir, then create $HOME/Sync
# Set simple file tracking and sync it with other computers

# Set wallpaper

# Nvim
# :updateRemotePlugins
# :PackUpdate

# Firefox
# Tridactyl
# :colors dark
# :set searchengine duckduckgo
# set newtab about:blank
# bind --mode=$mode $key $excmd
# https://github.com/tridactyl/tridactyl/blob/master/src/lib/config.ts
# bind --mode=normal x tabclose
# unbind --mode=normal t
# bind --mode=normal ty tabduplicate
# bind --mode=normal u scrollpage -0.5
# bind --mode=normal d scrollpage 0.5
# bind --mode=normal o fillcmdline tabopen
# bind --mode=normal O fillcmdline open
# bind --mode=normal X undo
# bind --mode=normal <A-Tab> buffer #
# bind --mode=normal <A-`> fillcmdline tab
# bind / fillcmdline find
# bind ? fillcmdline find -?
# bind ,<Space> nohlsearch
# bind n findnext 1
# bind N findnext -1

# about:config -> browser.proton.enabled = false


# set searchurls.g https://www.google.com/search?q=
# set searchurls.y https://www.youtube.com/results?search_query=
# set searchurls.r https://old.reddit.com/search?q=
# Alternate Player for Twitch.tv addon

# Evince
# Enable night mode
