# OUTSIDE

# if flashing img use to balena-etcher flash https://manjaro.org/download/#ARM architect edition (need to launch with sudo...)

# INSIDE
# ----------------------------------------------------------------------------

sudo pacman -Syyu

sudo pacman -S zsh zsh-autosuggestions mpv ranger atool alsa-utils zsh-completions zathura zathura-djvu zathura-pdf-mupdf youtube-dl xorg-xprop xorg-server wget unzip unrar ueberzug tree tmux tldr rsync r qutebrowser ctags dunst ffmpeg fzf git i3-gaps i3blocks ipython jack2 libnotify lsof neofetch pulseaudio pulseaudio-alsa pulseaudio-jack pavucontrol python-i3ipc python-pynvim python-pywal ripgrep ttf-ubuntu-font-family unclutter scrot redshift sxiv feh picom networkmanager pulsemixer xdotool rofi mpc mpd ncmpcpp transmission-cli transmission-gtk pass syncthing xclip python-dbus xorg-xinit ttf-nerd-fonts-symbols-mono ttf-linux-libertine ttf-joypixels xorg-xwininfo dmenu python-tldextract python-pip cadence python-pyperclip ttf-dejavu firefox firefox-ublock-origin firefox-extension-https-everywhere firefox-dark-reader firefox-tridactyl man-db evince a2jmidid glava ttf-font-awesome alacritty pcmanfm-gtk3 bash-language-server shellcheck python-language-server python-gobject

mkdir $HOME/Downloads $HOME/tmp $HOME/Videos $HOME/Pictures $HOME/pkgbuilds

cd $HOME/pkgbuilds
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si

yay -S neovim-nightly zsh-plugin-wd-git zsh-fast-syntax-highlighting-git navi pyradio-git htop-vim-git xcwd-git nerd-fonts-hack i3-layout-manager-git

git clone https://github.com/k-takata/minpac.git ~/.config/nvim/pack/minpac/opt/minpac

git config --global user.email "sarauskas.mantas@gmail.com"
git config --global user.name Mantas

git clone https://github.com/alexanderjeurissen/ranger_devicons ~/.config/ranger/plugins/ranger_devicons

chsh -s /usr/bin/zsh

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
