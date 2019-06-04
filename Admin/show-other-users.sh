#!/bin/bash
## Show "Other..." login
status=$(defaults read com.apple.loginwindow ShowOtherUsersManaged)

if [ "$status" == "1" ]; then
    echo "Preference already set"
else
    echo "Preference not set"
    defaults write com.apple.loginwindow ShowOtherUsersManaged -bool true
fi
exit 0
