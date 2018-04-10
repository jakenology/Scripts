#!/bin/bash
# Allow anyone to install a printer
# https://jamfnation.jamfsoftware.com/discussion.html?id=14640

dseditgroup -o edit -n /Local/Default -a everyone -t group lpadmin
defaults write /System/Library/LaunchAgents/com.apple.printuitool.agent.plist Disabled -bool YES
defaults write /System/Library/LaunchAgents/com.apple.printuitool.agent.plist EnableTransactions -bool NO
security authorizationdb write system.preferences allow
security authorizationdb write system.print.operator allow
echo All set.

exit 0;
