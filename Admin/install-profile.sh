#!/bin/bash
# Taken from: https://www.jamf.com/jamf-nation/discussions/29315/script-check-to-see-if-configuration-profile-is-installed
PROFILE_NAME="Disable Software Update Preference Pane"
profile=/tmp/profile.mobileconfig
link="https://s3.us-east-2.amazonaws.com/s3.jpits.us/profiles/com.apple.preferences.softwareupdate.mobileconfig"

## DO NOT MODIFY BELOW THIS LINE ##
profiles=`profiles -C -v | awk -F: '/attribute: name/{print $NF}' | grep "$PROFILE_NAME"`

    if [ "$profiles" == " $PROFILE_NAME" ]; then
            echo "Profile exists"
    else
            echo "Profile does not exists"
            curl -Lo $profile $link
            profiles -I -F $profile
exit 0
