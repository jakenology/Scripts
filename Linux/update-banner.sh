#!/bin/bash
## Login Banner Update Script
## Define Global Variables
bannerSource="https://raw.githubusercontent.com/jaykepeters/UniPi/master/banners/vpn"
bannerConfig="/etc/ssh/sshd_config"
LINE1="# SSH Login Message"
LINE2="Banner /etc/banner"

## Declare Functions
message() {
    echo "$1"
}

configCheck() {
    message "Checking Configuration..."
    addConfig() {
        message "Configuration Not Found..."
        message "Adding Configuration..."
        echo "" >> "${bannerConfig}"
        echo "$LINE1" >> "${bannerConfig}"
        echo "$LINE2" >> "${bannerConfig}"
        message "Configuration Added Successfully!"
    }

    updateMSG() {
        message "Updating Message..."
        mkdir /etc/Downloads
        wget "$bannerSource"
        mv ./vpn /etc/banner
        message "Message Updated!"
    }

    if grep -Fxq "$LINE2" /etc/ssh/sshd_config
    then
       updateMSG
    else
        addConfig
        UpdateMSG
    fi
    message "Everything looks Good!"
}

## Declare Main Function
main() {
    configCheck
}

## Start Me!!!
main
