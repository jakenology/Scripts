#!/bin/bash

## Quick Execution
curl -fkL https://raw.githubusercontent.com/jaykepeters/Scripts/master/install-screen_savers.sh | sh

## Set Variables
DESTINATION=~/Library/Screen\ Savers

## Download the Screen Savers ZIP file
curl -Lo "/tmp/Screen Savers.zip" https://github.com/jaykepeters/Screen-Savers/raw/master/Screen%20Savers.zip --silent

## Download the Success icon
curl -Lo "/tmp/Success.pdf" https://github.com/jaykepeters/Screen-Savers/raw/master/Success.pdf --silent

## Unzip files to the temp directory
unzip -oqq "/tmp/Screen Savers.zip" -d /tmp

## Move Screen Savers to their respective folder
for f in /tmp/Screen\ Savers/*
do
	rsync -av "${f}" "$DESTINATION"
done

## Remove the ZIP 
rm -R "/tmp/Screen Savers.zip"

## Remove the Screen Saver folder
rm -R "/tmp/Screen Savers"

## Remove the macos foklder
rm -R "/tmp/__MACOSX"

## Display Success Notification
osascript -e 'tell application "System Events"
	display dialog "Your Screen Savers have been successfully installed." buttons {"Thanks!"} default button {"Thanks!"} with icon {"/tmp/success.pdf"} giving up after 3
end tell' > /dev/null

## Open the Screensaver Pane
osascript -e 'tell application "System Preferences"
	activate
	reveal anchor "ScreenSaverPref" of pane "com.apple.preference.desktopscreeneffect"
end tell'

## Remove the success icon
rm -R /tmp/Success.pdf
