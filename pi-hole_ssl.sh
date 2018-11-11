#!/bin/bash
# Pi-hole SSL Activator 
# Created by Jayke Peters
# November 9, 2018
# Pretty much runs itself...
## Set Global Variables
CFG_FILE=/tmp/test.conf

function runSilentCommand() {
    #command="$@"
    #if [ -z "$command" ]; then
    if [ -z "$#" ]; then
        echo 'Null Usage of function runSilentCommand'
    else
        #exec bash -c "${command[@]}" &>/dev/null
        "$@" &>/dev/null
        if [ "$?" -gt 0 ]; then
            ecode="$?"
            echo -e "COMMAND FAILURE:\t" "${command[@]}"
            echo -e "EXIT CODE:\t" "$ecode"
            return "$ecode"
        else
            return 0
        fi
    fi
}

function installCertbot() {
    apt-get install -y software-properties-common python-software-properties
    add-apt-repository ppa:certbot/certbot
    apt-get update
}

function generateCert() {
    certbot --quiet --agree-tos --email "$email" certonly --webroot -w "$webroot" -d "$domain"
}

function editConfig() {
    "$@"
    # Check the number of args "Only One"
    if [ "$#" -gt "1" ]; then
        echo "Only one argument is allowed..."
    fi
}

function configCheck() {
    if [ ! -f "$CFG_FILE" ]; then
        echo "NO CONFIGURATION FILE"
        exit 1
    fi

    CFG_CONTENT=$(cat $CFG_FILE | sed -E '/[^=]+=[^=]+/!d' | sed -E 's/\s+=\s/=/g')
    eval "$CFG_CONTENT"

    neededVars=(
        EMAIL 
        WEBROOT
        DOMAIN
    )

    echo 'Certbot Configuration:'
    for var in "${neededVars[@]}"
    do
        if [ -n "${!var}" ]; then
            echo -e "\t $var: ${!var}"
        else
            echo -e "Missing Required Value:\t" [$var]
            echo -n "Please enter a value: "
            read input
            $var=$input
        fi
    done
    # Check to see if a configuration profile is set
    # If set, then check to  see if missing items.
    # If missing, items, get known ones, and ask user for unknown
    # All else fails, we cannot run this script in silent mode...
    # WOrst case, exit 1 with error status, user is smart and can fix

    #CFG_FILE=/etc/test.conf
    
}

function main() {
    # Testing the silent function. Will kill safari's parent process found in app path
    runSilentCommand 'kill -9 $(pgrep -f "Safari.app" | head -n 1)'
    runsilentCommand 'asd'
    configCheck
}

# Run Me!
main

# Options: interactive, verbose, silent, disable, uninstall