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

export PATH="$PATH:/Users/mlakin/.local/bin"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# load tmuxp session
if command -v tmux>/dev/null && test -z "$TMUX"; then
    tmuxp load -y 1 4 iac jamf dotfiles
fi
