#!/bin/bash
## Install Screen Savers
## Version 1.2.2
## Created by Jayke Peters on 2018-04-11
## MIT License

## Quick Execution
## curl -fkL https://raw.githubusercontent.com/jaykepeters/Scripts/master/install-screen_savers.sh | sh

## Set Variables
DESTINATION=~/Library/Screen\ Savers

## Download ZIP file
echo 'Downloading ZIP...'
curl -Lo "/tmp/Screen Savers.zip" https://github.com/jaykepeters/Screen-Savers/raw/master/Screen%20Savers.zip --silent > /dev/null

## Download Success icon
echo 'Downloading Installer Support Files...'
curl -Lo "/tmp/Success.pdf" https://github.com/jaykepeters/Screen-Savers/raw/master/Success.pdf --silent > /dev/null

## Wait
echo 'Processing...'
sleep 3

## Unzip files to temp
echo 'Unzipping files to /tmp...'
unzip -oqq "/tmp/Screen Savers.zip" -d /tmp > /dev/null
sleep 1

## Move Screen Savers to their folder
echo 'Moving files into place...'
for f in /tmp/Screen\ Savers/*
do
	rsync -av "${f}" "$DESTINATION" > /dev/null
done

## Remove ZIP 
echo 'Removing File 1 of 3...'
rm -R "/tmp/Screen Savers.zip" > /dev/null

## Remove the Screen Saver folder
echo 'Removing file 2 of 3...'
rm -R "/tmp/Screen Savers" > /dev/null

## Remove the macos foklder
echo 'removing file 3 of 3...'
rm -R "/tmp/__MACOSX" > /dev/null

## Wait
echo 'Processing'
sleep 3

## Display Success Notification
echo 'Displaying Success Alert...'
osascript -e 'tell application "System Events"
	display dialog "Your Screen Savers have been successfully installed." buttons {"Thanks!"} default button {"Thanks!"} with icon {"/tmp/success.pdf"} giving up after 3
end tell' > /dev/null

## Open the Screensaver Pane
echo 'Opening System Preferences...'
osascript -e 'tell application "System Preferences"
	activate
	reveal anchor "ScreenSaverPref" of pane "com.apple.preference.desktopscreeneffect"
end tell' > /dev/null

## Remove the success icon
echo 'Cleaning Up'
rm -R /tmp/Success.pdf > /dev/null

## Exit the Installer
echo 'Install Screensavers Complete! Exiting...'
echo 'QUITAPP\n'