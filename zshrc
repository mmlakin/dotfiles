# Homebrew
#
# First, so everything below can find brew-installed tools. Prefers the
# native Apple Silicon prefix and falls back to Intel. Never hardcode
# one prefix.
for brew_prefix in /opt/homebrew /usr/local; do
  if [[ -x $brew_prefix/bin/brew ]]; then
    eval "$($brew_prefix/bin/brew shellenv)"
    break
  fi
done
unset brew_prefix

# ~/.local/bin holds the native Claude Code install and pipx tools.
# ~/bin is for personal scripts.
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Layer hook, early. Work and personal layer repos link this file to
# set variables or preset plugins before anything below reads them.
[[ -f ~/.zshrc_local_before ]] && source ~/.zshrc_local_before

export DOTFILES="$HOME/.dotfiles"
export XDG_CONFIG_HOME="$HOME/.config"
if (( $+commands[nvim] )); then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

# pyenv
#
# Pins Python interpreters per project. Initialized before oh-my-zsh
# so its shims come first on PATH.
if (( $+commands[pyenv] )); then
  eval "$(pyenv init - zsh)"
fi

# oh-my-zsh
#
# Vendored as a submodule, so the submodule pin decides the version and
# omz's own updater is turned off. Its cache lives outside the
# submodule to keep the checkout clean.
export ZSH="$DOTFILES/oh-my-zsh"
export ZSH_CACHE_DIR="$HOME/.cache/oh-my-zsh"
zstyle ':omz:update' mode disabled

ZSH_THEME="refined"
DISABLE_AUTO_TITLE="true"
COMPLETION_WAITING_DOTS="true"

# Appended rather than assigned, so a layer can add its own in
# ~/.zshrc_local_before, for example `plugins=(aws)` for work.
plugins+=(
  brew
  fzf
  vi-mode
  git
  last-working-dir
  zoxide
  fancy-ctrl-z
)

source "$ZSH/oh-my-zsh.sh"
source "$DOTFILES/aliases"

# shellclear
#
# Scans shell history for leaked secrets at startup and reports what
# it finds.
if (( $+commands[shellclear] )); then
  eval "$(shellclear --init-shell)"
fi

# Layer hook, late. Aliases, functions and overrides that need
# everything above in place.
[[ -f ~/.zshrc_local_after ]] && source ~/.zshrc_local_after
