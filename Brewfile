# Baseline Brewfile
# ~~~~~~~~~~~~~~~~~
#
# Curated from mlakin's M1 Pro on 2026-10-03: 49 leaf formulae and 19
# casks reduced to what belongs on any Mac regardless of work or
# personal use. Terraform, AWS, Cloudflare, Jamf, LDAP and PowerShell
# tooling was dropped to the work layer, not deleted.
#
# Applied by ./install. Manually: brew bundle install --file=Brewfile --no-upgrade

# Tap for shellclear
#
# Only non-core tap in the baseline. Homebrew refuses to load formulae
# from untrusted taps, so ./install runs `brew tap` and `brew trust
# --tap rusty-ferris-club/tap` before `brew bundle`.
tap "rusty-ferris-club/tap"

# Shell and terminal core
#
# Everything the zshrc, tmux.conf and nvim config actually reference.
# Without these the dotfiles do not function.
brew "git"
brew "neovim"
brew "tmux"
brew "tmuxp"
brew "fzf"
# Prompt. zshrc runs `starship init zsh` when it is installed.
brew "starship"
brew "ripgrep"

# Required by nvim-treesitter to build parsers that ship no binary.
brew "tree-sitter"

# Scans shell history for leaked secrets. Wired into zshrc via
# `shellclear --init-shell` and into the tmuxp layouts.
brew "shellclear"

# Everyday command line
brew "bat"
brew "tree"
brew "jq"
brew "wget"
# tlrc is the official tldr client; the old tldr formula was removed.
brew "tlrc"
brew "watch"
brew "gh"
brew "shellcheck"
brew "sl"

# Network diagnostics
#
# General purpose rather than NerdWallet specific, so baseline rather
# than work layer.
brew "nmap"
brew "mtr"
brew "telnet"
brew "speedtest-cli"
brew "glances"
brew "iftop"
brew "lynx"

# Python toolchain
#
# pyenv pins the interpreter, pipx isolates CLI tools. Linters and
# formatters install through pipx, not brew, so they do not collide
# with project virtualenvs.
brew "pyenv"
brew "pipx"

# Terminal and fonts
#
# The nerd font supplies the glyphs vim-airline and the tmux status
# line expect. Without it both render as boxes.
cask "iterm2"
cask "font-hack-nerd-font"

# install.conf.yaml links pwsh/profile.ps1 and pwsh/modules.ps1 into
# ~/.config/powershell, so the baseline needs the shell itself or
# those links dangle. PowerShell moved from a cask to a core formula.
# The work-specific pwsh_local_after.ps1 that sources the Okta and
# Jamf API modules stays in the work layer.
brew "powershell"

# Daily applications
cask "alfred"
cask "claude"
cask "1password-cli"
cask "google-drive"
cask "caffeine"
cask "keka"
cask "vlc"

# Inspects .pkg contents before installing. General Mac hygiene.
cask "suspicious-package"
