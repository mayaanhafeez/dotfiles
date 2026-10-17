#!/usr/bin/env bash
# macos.sh — apply this machine's macOS settings. Safe to re-run.
#
# Values were read from the live machine with `defaults read`, so this
# reproduces the setup rather than a generic "sensible defaults" list.
# Light/dark appearance and accent colour are left to set-theme.
#
# Key repeat and a few others only take effect after logging out and back in.

set -euo pipefail

echo "→ dock"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0
defaults write com.apple.dock tilesize -int 51
defaults write com.apple.dock orientation -string left
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock launchanim -bool false
# Keep Spaces in a fixed order; Hyprspace workspaces depend on it
defaults write com.apple.dock mru-spaces -bool false
# Hot corners: top-left and bottom-right show the desktop (4)
defaults write com.apple.dock wvous-tl-corner -int 4
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-br-corner -int 4
defaults write com.apple.dock wvous-br-modifier -int 0

echo "→ menu bar"
# SketchyBar replaces the menu bar, so the real one stays hidden
defaults write NSGlobalDomain _HIHideMenuBar -bool true
defaults write NSGlobalDomain AppleMenuBarVisibleInFullscreen -bool false

echo "→ window management"
# macOS's own tiling and Stage Manager fight Hyprspace
defaults write com.apple.WindowManager GloballyEnabled -bool false
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false
defaults write com.apple.WindowManager EnableTopTilingByEdgeDrag -bool false
defaults write com.apple.WindowManager EnableTiledWindowMargins -bool false
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
defaults write NSGlobalDomain AppleMiniaturizeOnDoubleClick -bool false

echo "→ keyboard"
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
# Holding a key repeats it instead of showing the accent picker (vim)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

echo "→ trackpad"
# Tap to click, for the built-in trackpad, Bluetooth trackpads and the login screen
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool false

echo "→ finder"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool false
# List view, new windows open on the Documents folder
defaults write com.apple.finder FXPreferredViewStyle -string Nlsv
defaults write com.apple.finder NewWindowTarget -string PfDo
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true

echo "→ screenshots"
defaults write com.apple.screencapture type -string jpg

echo "→ restarting Dock, Finder and SystemUIServer"
killall Dock Finder SystemUIServer 2>/dev/null || true

echo ""
echo "Done. Log out and back in for key repeat and the menu bar setting to fully apply."
