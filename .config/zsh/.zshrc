# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Colored man pages
autoload colors && colors

# zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=completion

# jeffreytse/zsh-vi-mode
ZVM_INIT_MODE=sourcing
ZVM_CURSOR_STYLE_ENABLED=false

# Fzf 
export FZF_PATH="$XDG_DATA_HOME/fzf"

# Plugin manager
zstyle ':antidote:bundle' use-friendly-names 'yes'
source '/usr/share/zsh-antidote/antidote.zsh'
antidote load

# jeffreytse/zsh-vi-mode
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
VM_VI_HIGHLIGHT_FOREGROUND=black
VM_VI_HIGHLIGHT_BACKGROUND=white

zvm_vi_yank () {
	zvm_yank
	printf %s "${CUTBUFFER}" | xclip -sel c
	zvm_exit_visual_mode
}

# Fzf 
export FZF_DEFAULT_COMMAND='rg --files --follow --hidden --no-require-git --no-messages --glob "!.git/*" --glob "!node_modules/*"'
export FZF_DEFAULT_DIR_COMMAND='fd --type directory --follow --hidden --no-require-git --exclude ".git" --exclude "node_modules"'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND

if command -v lesspipe.sh > /dev/null; then
	export LESSOPEN="|lesspipe.sh %s"
	export LESSCOLORIZER=bat
fi

fzf_open_in_editor() {
	local files=$(eval ${FZF_DEFAULT_COMMAND} | fzf -m)
	if [ ! -z "$files" ]; then
		$EDITOR $files
	fi
	zle reset-prompt
}
zle -N fzf_open_in_editor
bindkey '^S' fzf_open_in_editor

fzf_cdf() {
	#local dir=$(eval ${FZF_DEFAULT_COMMAND} --null 2> /dev/null $HOME | xargs -0 dirname | sort --unique | fzf)
	local dir=$(eval ${FZF_DEFAULT_DIR_COMMAND} . $HOME | fzf --delimiter / --with-nth 4..)
	if [ ! -z "$dir" ]; then
		cd $dir
		zle accept-line
	fi
	zle reset-prompt
}
zle -N fzf_cdf
bindkey '^Q' fzf_cdf

# Aliases
# tmux lsd bat dust duf gping tuptime hyperfine procs ripgrep tldr viddy ugrep up hexyl mtr gdu doggo-bin advcpmv fcp qrcp bsdmainutils
function _alias() { command -v "$1" > /dev/null && alias "$2"="${3-$1}" }
# Basic
_alias ls	ls		'ls --color=auto'
_alias grep	grep		'grep --color=auto'
_alias git	dotconfig 	'git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# Custom
_alias duf	df
_alias gping	ping
_alias mtr	traceroute 	 
_alias tuptime	uptime
_alias ugrep 	grep
_alias nvim	vim
_alias gdu	ncdu
_alias doggo	dig
_alias nvim	vim
_alias mvg	mv		'mvg -g'
_alias cpg	cp		'cpg -g'
_alias lsd 	ls		'lsd --icon never'
_alias bat	cat		'bat --plain'
_alias bat	lessh		'bat --plain --paging=always --language=help'
_alias viddy	watch		'viddy --differences'
_alias dust	du		'dust -r'
_alias hexyl	xxd		'hexyl --border=none'
_alias ncal	cal		'ncal -bM'
_alias fd	fd		'fd --hidden'
_alias rg	rg		'rg --hidden --no-messages'
_alias bat	strace		"strace -o '| bat --plain --paging=never --language=strace'"
_alias procs	procsm		'procs --sortd MEM'	
_alias procs	procsc		'procs --sortd CPU'	
# History
_alias wget	wget		'wget --hsts-file=$XDG_CACHE_HOME/wget-hsts'
# Config
_alias tmux 	tmux 		'tmux -f $XDG_CONFIG_HOME/.tmux.conf'
unset -f _alias 

# Zsh options
HISTSIZE=1000000
SAVEHIST=1000000

setopt globdots # match hidden files without specifying dots
set -o ignoreeof # Disable CTRL-D
if [[ -t 0 && $- = *i* ]]; then
	stty -ixon # unbind C-S
	stty -ixoff # unbind C-Q
fi 

unsetopt BEEP

# Open editor via CTRL-E
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# Run command again via CTRL-P
function run-again {
    zle up-history
    zle accept-line
}
zle -N run-again
bindkey '^P' run-again 
bindkey -M vicmd '^P' run-again

# Up/Down in command history with j & k
bindkey '^j' down-history
bindkey -M vicmd '^j' down-history
bindkey '^k' up-history
bindkey -M vicmd '^k' up-history

# Vi mode cursor 
function _set_cursor() {
	echo -ne $1
}
function _set_block_cursor() { _set_cursor '\e[2 q' }
function _set_beam_cursor() { _set_cursor '\e[6 q' }
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] || [[ $1 = 'block' ]]; then
      _set_block_cursor
  else
      _set_beam_cursor
  fi
}
zle -N zle-keymap-select
precmd_functions+=(_set_beam_cursor)
zle-line-init() { zle -K viins; _set_beam_cursor }

command -v thefuck > /dev/null && eval $(thefuck --alias)
command -v pyenv > /dev/null && eval "$(pyenv init -)"

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
