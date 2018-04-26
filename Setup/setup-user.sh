#!/bin/bash

# Jayke's Mac Setup Script for User Settings

# Disable reopen in preview
defaults write com.apple.Preview NSQuitAlwaysKeepsWindows -bool false

# Disable QuickTime Re-Open
defaults write com.apple.QuickTimePlayerX NSQuitAlwaysKeepsWindows -bool false

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool YES; killall Dock &

# Disable iCloud Drive Saving
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable Crash Reporter
defaults write com.apple.CrashReporter DialogType none

# Enable path view in Finder
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES

# Make a recent applications folder in the Dock
defaults write com.apple.dock persistent-others -array-add '{ "tile-data" = { "list-type" = 1; }; "tile-type" = "recents-tile"; }'

# Disable verification of DMG's
defaults write com.apple.frameworks.diskimages skip-verify TRUE

# Notify the user that it was a success
echo User setup successful!!!

# Grab the serial numnber
serial=$(ioreg -c IOPlatformExpertDevice -d 2 | awk -F\" '/IOPlatformSerialNumber/{print $(NF-1)}')

# Disable the accidental Google Chrome swipe 
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool FALSE

echo -e 'SERIAL\t\t MAC' >> ~/Desktop/Results.log
echo $serial >> ~/Desktop/Results.log
