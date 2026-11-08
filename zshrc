# Homebrew
#
# First, so everything below can find brew-installed tools. Prefers the
# native Apple Silicon prefix and falls back to Intel. Never hardcode
# one prefix. shellenv also puts brew's zsh completions on fpath.
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
# set variables before anything below reads them.
[[ -f ~/.zshrc_local_before ]] && source ~/.zshrc_local_before

export DOTFILES="$HOME/.dotfiles"
export XDG_CONFIG_HOME="$HOME/.config"
if (( $+commands[nvim] )); then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

# History
#
# One large history shared live between all open shells, so a command
# run in one tab is searchable from another. Duplicates and commands
# typed with a leading space are left out.
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS

# Completion
#
# Tab opens a menu you can arrow through. Lowercase matches uppercase,
# so `cd doc<tab>` finds Documents.
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# vi mode
#
# Esc switches the command line to vi normal mode. KEYTIMEOUT=1 makes
# that switch take 10ms instead of the default 400ms. Backspace is
# rebound because vi's own version stops at the point where insert
# mode began, which feels broken after hopping back from normal mode.
bindkey -v
KEYTIMEOUT=1
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char

# fzf
#
# Ctrl-R fuzzy-searches history: type to narrow, Enter to pick. Also
# binds Ctrl-T to pick a file path and Alt-C to cd into a directory.
# Loaded after `bindkey -v` so its keys land in vi insert mode too.
if (( $+commands[fzf] )); then
  source <(fzf --zsh)
fi

# pyenv
#
# Pins Python interpreters per project. Its shims go first on PATH.
if (( $+commands[pyenv] )); then
  eval "$(pyenv init - zsh)"
fi

source "$DOTFILES/aliases"

# shellclear
#
# Scans shell history for leaked secrets at startup and reports what
# it finds.
if (( $+commands[shellclear] )); then
  eval "$(shellclear --init-shell)"
fi

# Prompt
#
# Starship, with its default config. Its prompt character changes in
# vi normal mode, so it doubles as the mode indicator.
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

# Layer hook, late. Aliases, functions and overrides that need
# everything above in place.
[[ -f ~/.zshrc_local_after ]] && source ~/.zshrc_local_after
