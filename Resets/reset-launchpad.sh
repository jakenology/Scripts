#!/bin/bash

## Reset Launchpad Version 1.0.1
## VERSION 1 Created and tested by Jayke Peters on 03/23/2018. 
## VERSION 1.0.1:         DESCRIPTION CHANGED BY JP on 6/16/18
## Deployable via macOS Server, Centrify, JumpCloud, Casper Suite/Jamf Pro as a Policy and other MDM solutions.
# Using the which command, the paths were specified as this script may fail when deployed via JumpCloud and Jamf Pro. 
## Jamf Pro JSS and Jamf Agent may set the $1, $2, $3 variables upon script deployment. This was tested and certified to work on JumpCloud by JP.
## ZOHO Desktop Central Depoloyment testing via server. Batch and Bash scripts ready.. Internal trial instance set to port 8888.

# Store the current user's username as a variable
currentuser=`stat -f "%Su" /dev/console`

# Reset the Launchpad
/usr/bin/sudo -u $currentuser /usr/bin/defaults write com.apple.dock ResetLaunchPad -bool true

# Refresh the Dock & Launchpad
/usr/bin/killall Dock

