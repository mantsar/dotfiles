#!/usr/bin/bash

sudo pacman -S zsh zsh-autosuggestions mpv ranger atool atom ardour alsa-utils acpi zsh-completions zathura zathura-djvu zathura-pdf-mupdf youtube-dl xorg-xprop xorg-server wget unzip unrar ueberzug tree tmux tldr supercollider sc3-plugins rsync r qutebrowser ctags dunst faust ffmpeg foxdot fzf git gnustep-base gnustep-make haskell-tidal i3-gaps i3blocks ipython jack2 japa libnotify lsof luarocks lv2 neofetch pandoc pandoc-citeproc pulseaudio pulseaudio-alsa pulseaudio-jack pavucontrol python-i3ipc python-pynvim python-pywal ripgrep ttf-ubuntu-font-family unclutter scrot redshift sxiv feh picom networkmanager pulsemixer xdotool rofi mpc mpd ncmpcpp transmission-cli transmission-gtk pass syncthing pd xclip python-dbus xorg-xinit ttf-nerd-fonts-symbols-mono ttf-linux-libertine ttf-joypixels xorg-xwininfo dmenu python-tldextract python-pip cadence python-pyperclip ttf-dejavu firefox firefox-ublock-origin firefox-extension-https-everywhere firefox-dark-reader firefox-tridactyl man-db evince a2jmidid glava ttf-font-awesome alacritty pcmanfm-gtk3 acpilight bash-language-server shellcheck python-language-server python-gobject

mkdir $HOME/Downloads $HOME/tmp $HOME/Videos $HOME/Pictures $HOME/pkgbuilds

cd $HOME/pkgbuilds
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

yay -S neovim-nightly zsh-plugin-wd-git zsh-fast-syntax-highlighting-git navi pyradio-git htop-vim-git xcwd-git nerd-fonts-hack i3-layout-manager-git neovide ttf-fira-code

git clone https://github.com/k-takata/minpac.git ~/.config/nvim/pack/minpac/opt/minpac

git config --global user.email "sarauskas.mantas@gmail.com"
git config --global user.name Mantas

git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons
# echo "default_linemode devicons" >> $HOME/.config/ranger/rc.conf

chsh -s /usr/bin/zsh
# source $HOME/.zshrc

mkdir $HOME/.cache/zsh && touch $HOME/.cache/zsh/history

alias d="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME"
git clone --bare https://www.github.com/mantsar/dotfiles.git $HOME/.dotfiles.git
d checkout
/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME remote set-url origin ssh://git@github.com/mantsar/dotfiles.git
/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME config --local status.showUntrackedFiles no

mkdir $HOME/.config/mpd/playlists

# i3
pip3 install --user i3-workspace-names-daemon

# tmux
git clone https://github.com/tmux-plugins/tmux-resurrect $HOME/pkgbuilds/tmux-resurrect

# MANUALLY -------------------------

# Syncthing
# http://127.0.0.1:8384
# Delete default dir, then create $HOME/Sync

# Set wallpaper

# Nvim
nvim --headless +updateRemotePlugins +qa
nvim --headless +PackUpdate +qa

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
# set searchurls.g https://www.google.com/search?q=
# set searchurls.y https://www.youtube.com/results?search_query=
# set searchurls.r https://old.reddit.com/search?q=

# Evince
# Enable night mode
