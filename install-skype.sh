#!/bin/bash

# This script will download and install Google Chrome on a fresh installation of Mac OS X.
# Usage: curl -fkL gist.github.com/raw/4364590/install-chrome.sh | sh

osascript /Users/jaykepeters/Desktop/mac-setup.dialog.scpt

curl -Lo /tmp/Skype.dmg https://go.skype.com/mac.download;
hdiutil attach -noverify -nobrowse /tmp/Skype.dmg;
ditto -rsrc /Volumes/Skype/Skype.app /Applications/Skype.app;
hdiutil detach /Volumes/Skype;
rm /tmp/Skype.dmg;