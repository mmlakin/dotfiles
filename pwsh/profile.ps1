# Load local_before profile
if (Test-Path "~/.config/powershell/pwsh_local_before") {
    . ~/.config/powershell/pwsh_local_before
}

# Tab completion
Set-PSReadlineKeyHandler -Key Tab -Function tabcompletenext
Set-PSReadlineKeyHandler -Key "Shift+Tab" -Function TabCompletePrevious

# Navigation
Set-PSReadLineKeyHandler -Chord 'Ctrl+LeftArrow' -Function 'BackwardWord'
Set-PSReadLineKeyHandler -Chord 'Ctrl+RightArrow' -Function 'ForwardWord'

# Add local system binaries to path
$env:PATH += ":/usr/local/bin"

# Load local_after profile
if (Test-Path "~/.config/powershell/pwsh_local_after") {
    . ~/.config/powershell/pwsh_local_after
}

# shellclear
shellclear --init-shell
