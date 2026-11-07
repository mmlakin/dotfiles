#!/usr/bin/env bash
#
# macOS baseline defaults
# ~~~~~~~~~~~~~~~~~~~~~~~
#
# Harvested from mlakin's M1 Pro on 2026-10-03. Every value below was
# read off that machine with `defaults read` unless marked DESIRED,
# which means it was not set there but was asked for explicitly.
#
# Safe to re-run. Nothing here needs sudo. Run by ./install.

set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "macos-defaults.sh: not macOS, skipping"
    exit 0
fi

# Map caps lock to escape
#
# macOS stores this per keyboard, keyed by vendor-product id, so the
# ids differ on every machine and cannot be hardcoded. Discover the
# attached keyboards instead and write the mapping for each.
# 0x700000039 is caps lock, 0x700000029 is escape.
# Takes effect at next login.
remap_caps_lock_to_escape() {
    local keyboard_ids
    keyboard_ids=$(
        ioreg -c AppleDeviceManagementHIDEventService -r -l 2>/dev/null |
            awk '/"VendorID"/{v=$NF} /"ProductID"/{p=$NF; if (v && p) print v"-"p"-0"}' |
            sort -u
    )

    if [[ -z "$keyboard_ids" ]]; then
        echo "  no keyboards found, skipping caps lock remap"
        return 0
    fi

    local keyboard_id
    while IFS= read -r keyboard_id; do
        echo "  remapping caps lock on ${keyboard_id}"
        defaults -currentHost write NSGlobalDomain \
            "com.apple.keyboard.modifiermapping.${keyboard_id}" \
            '(
                {
                    HIDKeyboardModifierMappingSrc = 30064771129;
                    HIDKeyboardModifierMappingDst = 30064771113;
                }
            )'
    done <<<"$keyboard_ids"

    # The defaults above only load at login. hidutil applies the same
    # mapping to the running session so it works immediately.
    hidutil property --set \
        '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x700000029}]}' \
        >/dev/null
}

echo "Remapping caps lock to escape"
remap_caps_lock_to_escape

# Bind shift-cmd-4 to clipboard instead of file
#
# By default shift-cmd-4 writes a file to the desktop (hotkey 30) and
# ctrl-shift-cmd-4 copies to the clipboard (hotkey 31). Disable 30 and
# move its key combo onto 31 so the muscle memory lands on the
# clipboard and no desktop clutter accumulates.
# 52 is ascii '4', 21 is its keycode, 1179648 is shift+cmd.
# Takes effect at next login.
echo "Binding shift-cmd-4 to clipboard"

defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 30 '
    <dict>
        <key>enabled</key><false/>
        <key>value</key>
        <dict>
            <key>type</key><string>standard</string>
            <key>parameters</key>
            <array>
                <integer>52</integer>
                <integer>21</integer>
                <integer>1179648</integer>
            </array>
        </dict>
    </dict>
'

defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 31 '
    <dict>
        <key>enabled</key><true/>
        <key>value</key>
        <dict>
            <key>type</key><string>standard</string>
            <key>parameters</key>
            <array>
                <integer>52</integer>
                <integer>21</integer>
                <integer>1179648</integer>
            </array>
        </dict>
    </dict>
'

# Configure dock
#
# Zero delay and zero animation make the autohidden dock feel instant
# rather than hidden, which is the only reason autohide is tolerable.
echo "Configuring dock"

defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock tilesize -int 63
defaults write com.apple.dock largesize -int 128

# Recents and most-recently-used space reordering both move targets
# around under the cursor.
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock mru-spaces -bool false

# DESIRED: macOS ships Quick Note on the bottom-right corner, which
# fires on any overshoot toward the dock. 0 is no action.
defaults write com.apple.dock wvous-br-corner -int 0

# Empty the dock, once
#
# A new Mac's dock is all of Apple's promoted apps. Clearing it is the
# single biggest "this is mine now" change. Apps you actually want are
# a layer concern, not baseline, so nothing is added back here.
# ./install runs this script every time, so a marker file keeps reruns
# from wiping apps pinned since. Delete the marker to empty it again.
dock_marker="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles/dock-emptied"
if [[ ! -e "$dock_marker" ]]; then
    echo "Emptying dock"
    defaults write com.apple.dock persistent-apps -array
    defaults write com.apple.dock persistent-others -array
    mkdir -p "$(dirname "$dock_marker")"
    touch "$dock_marker"
fi

# Configure finder
echo "Configuring finder"

# List view everywhere. Nlsv is list, icnv is icon, clmv is column,
# Flwv is gallery.
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
defaults write com.apple.finder ShowStatusBar -bool true

# New windows open at home rather than Recents.
defaults write com.apple.finder NewWindowTarget -string "PfHm"

# The boot volume on the desktop is noise, external media is not.
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false

# Configure menu bar clock
#
# 24-hour with seconds, because log timestamps are read against it.
echo "Configuring menu bar clock"

defaults write com.apple.menuextra.clock Show24Hour -bool true
defaults write com.apple.menuextra.clock ShowSeconds -bool true
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true
defaults write com.apple.menuextra.clock ShowDate -int 1

# Configure appearance and file handling
echo "Configuring appearance"

defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Hidden extensions make it possible to mistake a .app for a document.
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Restart affected apps
#
# Dock, Finder and SystemUIServer reread their prefs on launch only.
# Keyboard remapping and the screenshot hotkeys need a full re-login.
echo "Restarting Dock, Finder and SystemUIServer"

for app in Dock Finder SystemUIServer; do
    killall "$app" >/dev/null 2>&1 || true
done

# Symbolic hotkeys only reload at login. The private activateSettings
# -u trick crashes on macOS 15, so there is no reliable live reload.
echo
echo "Done. Log out and back in once for the shift-cmd-4 binding."
