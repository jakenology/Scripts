#!/bin/bash
## Google Chrome Install Script
function install() {
    # Install Google Chrome
    curl -sSL https://raw.githubusercontent.com/jaykepeters/Scripts/Deployment/Installs/GoogleChromeInstall.sh | bash

    # Enable Updates
    curl -sSL https://raw.githubusercontent.com/hjuutilainen/adminscripts/master/chrome-enable-autoupdates.py | python -
}

if [ "$EUID" -ne 0 ]; then
    echo "You must run this script as root"
else
    if [ ! -d "/Applications/Google Chrome.app" ]; then
        echo "Google Chrome is not installed"
        install
    else
        echo "Google Chrome is installed"
    fi
fi
