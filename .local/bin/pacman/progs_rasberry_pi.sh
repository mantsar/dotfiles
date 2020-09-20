#!/usr/bin/bash

sudo pacman -Syyu

sudo pacman -S base-devel zsh zsh-autosuggestions zsh-completions fzf git neofetch pavucontrol redshift mpd syncthing python-pip firefox firefox-ublock-origin firefox-dark-reader firefox-tridactyl cantana

mkdir $HOME/Downloads $HOME/tmp $HOME/Videos $HOME/Pictures $HOME/pkgbuilds

cd $HOME/pkgbuilds
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

yay -S neovim-git zsh-plugin-wd-git zsh-fast-syntax-highlighting-git navi pyradio-git

git clone https://github.com/k-takata/minpac.git ~/.config/nvim/pack/minpac/opt/minpac

git config --global user.email "sarauskas.mantas@gmail.com"
git config --global user.name Mantas

chsh -s /usr/bin/zsh
sudo chsh -s /bin/zsh

mkdir $HOME/.cache/zsh && touch $HOME/.cache/zsh/history

/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME config --local status.showUntrackedFiles no

mkdir $HOME/.config/mpd/playlists

# MANUALLY -------------------------

# Syncthing
# http://127.0.0.1:8384
# Delete default dir, then create $HOME/Sync

# Nvim
# nvim --headless +updateRemotePlugins +qa
# nvim --headless +PackUpdate +qa

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
