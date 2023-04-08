export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache

# Application config/data/cache remap
export ZDOTDIR=$XDG_CONFIG_HOME/zsh
export NVM_DIR=$XDG_DATA_HOME/nvm
export PYENV_ROOT=$XDG_DATA_HOME/pyenv
export PYTHONPYCACHEPREFIX=$XDG_CACHE_HOME/python
export PYTHONUSERBASE=$XDG_DATA_HOME/python
export NODE_REPL_HISTORY="$XDG_DATA_HOME"/node_repl_history
export GOPATH="$XDG_DATA_HOME"/go
export GOMODCACHE="$XDG_CACHE_HOME"/go/mod
export FFMPEG_DATADIR="$XDG_CONFIG_HOME"/ffmpeg
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export WORKON_HOME="$XDG_DATA_HOME/virtualenvs"

# Misc
export EDITOR=$(command -v nvim > /dev/null && echo nvim || echo vim)

typeset -U path
path=(/home/$USER/.local/bin:$PATH
      /home/$USER/.local/share/python/bin
      $PYENV_ROOT/bin
      $path)
export PATH

[ -e "$HOME/.zshenv_local" ] && source $HOME/.zshenv_local
