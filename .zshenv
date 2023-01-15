export GTK_THEME=Adwaita:dark
export XDG_CONFIG_HOME=$HOME/.config
export NLS_LANG=LATVIAN_LATVIA.AL32UTF8
export ZDOTDIR=$HOME/.config/zsh
export EDITOR=$(command -v nvim && echo nvim || echo vim)
export PYENV_ROOT="$HOME/.pyenv"
export NVM_DIR="$HOME/.config/nvm"

typeset -U path
path=(/home/vnsmits/.local/bin:$PATH
      $PYENV_ROOT/bin
      $path)
export PATH
