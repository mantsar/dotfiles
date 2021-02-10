# General
setopt autocd # Automatically cd into typed directory.
setopt extended_glob
stty stop undef # Disable ctrl-s to freeze terminal.
setxkbmap -option ctrl:nocaps

# Prompt
autoload -U promptinit;
declare +x PS1 # Dont export prompt
# Substitute environmental variables
setopt prompt_subst
autoload -U colors && colors
PS1='%F{green}%B[%n@%m %F{yellow}%1~%F{green}]$%b %F{white}'

# History settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history
setopt INC_APPEND_HISTORY # Write to the history file immediately
setopt share_history # Share history between all sessions
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS # Don't record an entry that was just recorded again.
setopt HIST_SAVE_NO_DUPS # Don't write duplicate entries in the history file.
setopt HIST_IGNORE_ALL_DUPS # Delete old recorded entry if new entry is a duplicate.
setopt HIST_REDUCE_BLANKS # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY # Don't execute immediately upon history expansion.
setopt HIST_IGNORE_SPACE # Don't record an entry with spaces.

# Completion settings
autoload -Uz compinit  # Basic auto/tab complete:
zstyle ':completion:*' menu select # Enables menu in completion
compinit
_comp_options+=(globdots) # Include hidden files.

# VI MODE
bindkey -v
export KEYTIMEOUT=1 # Delay between ESC and mode change
# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.
bindkey -M viins '^d' delete-char
bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^b' backward-char
bindkey -M viins '^f' forward-char
bindkey -M viins '^a' beginning-of-line
bindkey -M viins '^e' end-of-line
bindkey -M viins '^k' kill-line
bindkey '^p' up-line-or-history # to match beginning use: history-search-backward 
bindkey '^n' down-line-or-history # to match beginning use: history-search-forward
# bindkey '^r' history-incremental-search-backward
bindkey -M viins '^[f' forward-word
bindkey -M viins '^[b' backward-word
bindkey -M viins '^[p' up-line
bindkey -M viins '^[n' down-line
# Need to remamp again, because it's overwritten when entering normal mode
bindkey -M viins '^w' backward-kill-word 
bindkey -M viins '^u' backward-kill-line
bindkey -M viins '^?' backward-delete-char
# Edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^[e' edit-command-line

# Functions
function cd {
	builtin cd "$@" && ls -F
}

function gitacp() {
	git add -u # stages modifications and deletions, without new files (all project scope)
	git commit -m "$1"
	git push
}

# cdf - cd into the directory of the selected file
cdf() {
   local file
   local dir
   file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}
bindkey -s '^o' 'cdf\n'

# FZF
# history
fh() {
  print -z $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]* *//')
}
bindkey -s '^r' 'fh\n'
bindkey -s '^[r' 'cd "$(dirname "$(fzf)")"\n'

# WD
wd() {
  . /usr/share/wd/wd.sh
}

function knit() {
    R -e "rmarkdown::render('$1')"
    qutebrowser --target window "$(basename $1 .Rmd).html"
}

# ALIASES
# Colorize commands when possible.
alias \
	ls="ls -hN --color=auto --group-directories-first" \
	grep="grep --color=auto" \
	diff="diff --color=auto" \
	ccat="highlight --out-format=ansi"

# Verbosity and settings that you pretty much just always are going to want.
alias \
	bat="cat /sys/class/power_supply/BAT?/capacity" \
	cp="cp -iv" \
	mv="mv -iv" \
	rm="rm -v" \
	mkdir="mkdir -pv" \
	mkd="mkdir"

# These common commands are just too long! Abbreviate them.
# ffmpeg -y option to always overwrite output
alias \
	g="git" \
	d="/usr/bin/git --git-dir=$HOME/.dotfiles.git/ --work-tree=$HOME" \
	da="d add -u && d reset -- $HOME/.config/alacritty/alacritty.yml $HOME/.config/i3blocks/config" \
	trem="transmission-remote" \
	px="pwd | xclip -r" \
	sdn="sudo shutdown -h now" \
	e="$EDITOR" \
	v="$EDITOR" \
	vim="nvim" \
	nv="neovide --geometry=210x50" \
	ff="ffmpeg -f x11grab -video_size 1920x1080 -framerate 60 -i $DISPLAY" \
	p="sudo pacman" \
	pu="sudo pacman -Syyu" \
	lst="ls -laht | grep '^-' | head" \
	lsa="ls -lah" \
	t="tmux" \
	ta="tmux attach -t" \
	tk="tmux kill-session -t" \
	tl="tmux ls" \
	tn="tmux new -s" \
	ov="sudo openfortivpn" \
	ms="systemctl start mongodb" \
	mS="systemctl stop mongodb" \
	mss="systemctl status mongodb" \
	sn="sp_new a" \
	a="$HOME/sp/a" \
	sp="$HOME/sp"

# Directories
alias \
	c="$HOME/.config" \
	cq="$HOME/.config/qutebrowser" \
	cl="$HOME/.config/i3-layout-manager/layouts" \
	dw="$HOME/Downloads" \
	h="$HOME" \
	m="$HOME/Music" \
	u="/mnt" \
	pp="$HOME/Pictures" \
	s="$HOME/.local/bin" \
	S="$HOME/Sync" \
	M="$HOME/Bitwig\ Studio/Library/Templates/midi_export.bwtemplate/project" \
	vv="$HOME/Videos" \
	cS="$HOME/.config/SuperCollider" \
	cs="$HOME/.config/SuperCollider/synthdef" \
	cf="$HOME/.config/SuperCollider/Extensions/Faust"

# Files
alias \
	cfz="$EDITOR $HOME/.zshrc" \
	cfv="$EDITOR $HOME/.config/nvim/init.vim" \
	cfr="$EDITOR $HOME/.config/ranger/rc.conf" \
	cft="$EDITOR $HOME/.tmux.conf" \
	cfi="$EDITOR $HOME/.config/i3/config" \
	cfb="$EDITOR $HOME/.config/i3blocks/config"

# R
# shiny.autoreload = TRUE,
alias shiny='R -e "options(shiny.launch.browser = TRUE, browser = \"/usr/bin/firefox\") ; shiny::runApp("port=7838")"' \
	rmarkdown='R -e "options(shiny.launch.browser = TRUE, browser = \"/usr/bin/firefox\") ; rmarkdown::run(\"report.Rmd\", shiny_args = list(port = 7840))"' \
	rmd='R -e "options(shiny.launch.browser = TRUE, browser = \"/usr/bin/firefox\") ; rmarkdown::run(\"app.Rmd\", shiny_args = list(port = 7840))"' \
	ri='R -e "renv::init()"' \
	rs='R -e "renv::snapshot()"' \
	rr='R -e "renv::restore()"' \
	ra='R -e "renv::activate()"' \
	rd='R -e "renv::deactivate()"' \
	rh='R -e "renv::history()"' \
	rrev='R -e "renv::revert()"'

# Load plugins. Should be last.
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
# bindkey '^f' autosuggest-accept
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
# Navi (commands cheatsheet)
source <(navi widget zsh)
bindkey '^s' _call_navi

source ~/.local/bin/zsh/sudo.plugin.zsh
bindkey '^[q' sudo-command-line
bindkey -M vicmd '^[q' sudo-command-line

[ -e ~/.aliases ] && source ~/.aliases

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/home/mantas/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/home/mantas/miniconda3/etc/profile.d/conda.sh" ]; then
#         . "/home/mantas/miniconda3/etc/profile.d/conda.sh"
#     else
<<<<<<< HEAD
#         export PATH="/home/mantas/miniconda3/bin:$PATH"
=======
        # export PATH="/home/mantas/miniconda3/bin:$PATH"
>>>>>>> 5b107dc0f6fc6bde3935c96883958da40fd73877
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<
