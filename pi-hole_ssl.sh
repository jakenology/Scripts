#!/bin/bash
# Pi-hole SSL Activator 
# Created by Jayke Peters
# November 9, 2018
# Pretty much runs itself...
## Set Global Variables
CFG_FILE=/tmp/test.conf
hostname="www.example.com"

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
    apt-get install certbot
}

function generateCert() {
    certbot --quiet --agree-tos --email "$email" certonly --webroot -w "$webroot" -d "$domain"
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
}

function editConfig() {
    "$@"
    # Check the number of args "Only One"
    if [ "$#" -gt "1" ]; then
        echo "Only one argument is allowed..."
    fi
}

function find_replace() {
    # Ensure File Exists
    if [ ! -f "$3" ]; then 
        return 1
    else
        findString="$1"
        replaceString="$2"
        fixFile="$3"
        orig="${fixFile}.orig"
        bak="${fixFile}.bak"

        # Backup the Original File
        if [ ! -f "$orig" ]; then
            echo -e "BACKING UP FILE:\t" "$fixFile"
            cp -R "$fixFile" "$orig"
        fi

        # Backup the Current Configuration
        if [ -f "$bak" ]; then
            echo -e "REMOVING EXISTING BACKUP:\t" "$bak"
            rm -rif "$bak"
        else
            echo -e "BACKING UP:\t" "$fixFile"
            cp -R "$fixFile" "$bak"
        fi
        
        # Find and Replace Strings
        sed -i "" 's#'${findString}'#'${replaceString}'#g' "$fixFile"

        # Some versions of SED will not play nice...
        if [ "$?" -ne "0" ]; then
            echo -e "replace_strings exited with:\t $?" "Retrying..."
            sed -i 's#'${findString}'#'${replaceString}'#g' "$fixFile"
            if [ "$?" -ne "0" ]; then
                echo -e "find_replace:\t" "exited with:\t" "$?"
            fi
        fi

        echo -e "$findString REPLACED WITH $replaceString IN $fixFile"
        echo -e "REMOVING:\t" "$bak"
        rm -rif "$bak"
    fi
}

function apply_settings() {
    find_replace "http://127.0.0.1" "https://$hostname" "/tmp/example.txt"
    #service lighttpd reload
}

function main() {
   #configCheck
    apply_settings
}

# Run Me!
main

# Options: interactive, verbose, silent, disable, uninstall
