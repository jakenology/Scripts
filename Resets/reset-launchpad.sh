#!/bin/bash

## Reset Launchpad Version 1.0
## Created and tested by Jayke Peters on 03/23/2018. 
## Deployable via macOS Server, Centrify, JumpCloud, Casper Suite/Jamf Pro as a Policy and other MDM solutions.
# Note that the ".sh" file extension is not needed as long as the shebang is on top (the interpreter).
# Using the which command, the paths were specified as this script may fail when deployed via Casper Suite/Jamf Pro.
# In the event that this script fails via Self Service, you may need to find another way to run it as the logged in user via Jamf Nation.

# Store the current user's username as a variable
currentuser=`stat -f "%Su" /dev/console`

# Reset the Launchpad
/usr/bin/sudo -u $currentuser /usr/bin/defaults write com.apple.dock ResetLaunchPad -bool true

# Refresh the Dock & Launchpad
/usr/bin/killall Dock

