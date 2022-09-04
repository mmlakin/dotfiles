export DOTFILES="$HOME/.dotfiles"
export XDG_CONFIG_HOME="$HOME/.config"
export ZSH="$DOTFILES/oh-my-zsh"

ZSH_THEME="refined"
DISABLE_AUTO_TITLE="true"
COMPLETION_WAITING_DOTS="true"

# oh-my-zsh plugin list
plugins=(
  aws
  brew
  fzf
  vi-mode
  git
  last-working-dir
  fasd
  fancy-ctrl-z
)

source $ZSH/oh-my-zsh.sh
autoload -U compinit
eval $(shellclear --init-shell)

# Created by `pipx` on 2022-07-29 04:04:03
export PATH="$PATH:/Users/mlakin/.local/bin"
