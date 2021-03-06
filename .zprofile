#!/bin/zsh

# zsh profile file. Runs on login. Environmental variables are set here.

# Adds `~/.local/bin` to $PATH
# export PATH="$PATH:$(du "$HOME/.scripts/" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"
export PATH="$PATH:$(du "$HOME/.local/bin/" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"
export PATH="$PATH:$HOME/.config/qutebrowser/userscripts"
export PATH="$PATH:$HOME/bin"

# Default programs:
export EDITOR="nvim"
# export TERMINAL="termite"
export TERMINAL="alacritty"
export BROWSER="qutebrowser"
export READER="zathura"
export FILE="ranger"
export SHELL="zsh"
export MYVIMRC="$HOME/.config/nvim/init.vim"
export TIDAL_BOOT_PATH="$HOME/sp/tidal/Tidal.ghci"
export LV2_PATH="$HOME/.config/SuperCollider/synthdef"

# Start graphical server on tty1 if not already running.
[ "$(tty)" = "/dev/tty1" ] && ! ps -e | grep -qw Xorg && exec startx

if [[ -z $DISPLAY && $(tty) == /dev/tty2 ]]; then
  XDG_SESSION_TYPE=x11 GDK_BACKEND=x11 exec startx
fi
