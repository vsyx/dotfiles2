# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh//.zshrc.
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
export FZF_PATH="$XDG_CONFIG_HOME/fzf"
export FZF_PREVIEW_WINDOW='right:65%:nohidden'

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
export FZF_CTRL_T_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*" --glob "!node_modules/*" --glob "!vendor/*" 2> /dev/null'

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias dotconfig='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# tmux lsd bat dust duf gping tuptime hyperfine procs ripgrep tldr viddy ugrep up hexyl mtr gdu doggo-bin advcpmv fcp qrcp bsdmainutils
function _alias() { command -v "$1" > /dev/null && alias "$2"="${3-$1}" }
_alias duf	df
_alias gping	ping
_alias mtr	traceroute 	
_alias tuptime	uptime
_alias ugrep 	grep
_alias nvim	vim
_alias gdu	ncdu
_alias doggo	dig
_alias nvim	vim
_alias grace	strace
_alias mvg	mv		'mvg -g'
_alias cpg	cp		'cpg -g'
_alias tmux 	tmux 		'tmux -f $XDG_CONFIG_HOME/.tmux.conf'
_alias lsd 	ls		'lsd --icon never'
_alias bat	cat		'bat --plain --theme base16'
_alias viddy	watch		'viddy --differences'
_alias dust	du		'dust -r'
_alias hexyl	xxd		'hexyl --border=none'
_alias ncal	cal		'ncal -bM'
_alias fd	fd		'fd -H'
_alias procs	procsm		'procs --sortd MEM'	
_alias procs	procsc		'procs --sortd CPU'	
unset -f _alias

# Misc options
HISTSIZE=1000000
SAVEHIST=1000000
setopt globdots # match hidden files without specifying dots
set -o ignoreeof # Disable CTRL-D
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
