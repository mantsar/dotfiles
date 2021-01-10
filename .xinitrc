if [ $(tty) == /dev/tty1 ]; then
  exec i3
  xset r rate 200 50
  [[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
fi

if [ $(tty) == /dev/tty2 ]; then
  export XDG_SESSION=TYPE=x11
  export GDK_BACKEND=x11
  exec gnome-session
  [[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap
fi

# Add this to your .xinitrc or whatever file starts programs on startup.
