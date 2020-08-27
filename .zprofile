#!/bin/zsh

# zsh profile file. Runs on login. Environmental variables are set here.

# Adds `~/.local/bin` to $PATH
# export PATH="$PATH:$(du "$HOME/.scripts/" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"
export PATH="$PATH:$(du "$HOME/.local/bin/" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"
export PATH="$PATH:$HOME/.config/qutebrowser/userscripts"

# Default programs:
export EDITOR="nvim"
export TERMINAL="termite"
export BROWSER="qutebrowser"
export READER="zathura"
export FILE="ranger"
export SHELL="zsh"
export MYVIMRC="$HOME/.config/nvim/init.vim"
export TIDAL_BOOT_PATH="$HOME/sp/tidal/Tidal.ghci"
export LV2_PATH="$HOME/.config/SuperCollider/synthdef"

# Start graphical server on tty1 if not already running.
[ "$(tty)" = "/dev/tty1" ] && ! ps -e | grep -qw Xorg && exec startx
