#!/bin/bash
# Pi-hole SSL Activator 
# Created by Jayke Peters
# November 9, 2018
## Set Global Variables
CFG_FILE=/tmp/test.conf
hostname="www.example.com"

function silent() {
    RED='\033[1;31m'
    NC='\033[0m'
    if [ "$#" -lt 1 ]; then
        echo "${FUNCNAME[0]}: I need at least one argument"
    else
        bash -c "$*" &>/dev/null
        ec="$?"
        if [ "$ec" -gt 0 ]; then
            echo -e "${RED}ERROR:\n${NC}" \
            "\tCOMMAND:\t ${FUNCNAME[0]} $*\n" \
            "\tEXIT CODE:\t ${RED}$ec${NC}" 
            return 1
        fi
    fi
}

function installCertbot() {
    apt-get install -y software-properties-common python-software-properties
    add-apt-repository -y ppa:certbot/certbot
    apt-get -y update
    apt-get -y install certbot
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
            #echo -e "REMOVING EXISTING BACKUP:\t" "$bak"
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

function get_file() {
    url="$1"
    file="$2"
    # Get Content Length
    cl=$(curl -sI $url | grep -i Content-Length | awk '{print $2}')
    silent curl -sL "$url" -o "$file"

    # Verify File Size
    fs="$(wc -c <"$file")"
    if [ "$fs" = "$cl" ]; then
        echo $fs $cl
    fi

    s1=$cl
    s2=$fs
}

function apply_settings() {
    find_replace "http://127.0.0.1" "https://$hostname" "/tmp/example.txt"
    find_replace "hostname" "$hostname" "/etc/lighttpd/external.conf"
}

function main() {
    configCheck
    apply_settings
}

help() {
    # Color Choices
    red='\033[0;31m'
    Bred='\033[1;31m'
    yellow='\033[0;33m'
    blu='\033[0;34m'
    nc='\033[0m'
    
    # Hello, my name is?
    me=`basename "$0"`

    echo -e "${Bred}USAGE:
    ${nc}\t$me ${yellow}[-ed] [-ivs]
${Bred}OPTIONS:
    \t${yellow}-e, --enable 
    \t${blu}Enables HTTPS on the Pi-hole Admin Interface\n
    \t${yellow}-d, --disable  
    \t${blu}Disables HTTPS on the Pi-hole Admin Interface
${Bred}MODIFIERS:
    \t${yellow}-i, --interactive
    \t${blu}Asks for input if additional information is needed\n
    \t${yellow}-v, --verbose
    \t${blu}Displays real time information and command output\n
    \t${yellow}-s, --silent
    \t${blu}Displays no output, except for errors and exit codes 
${Bred}EXAMPLES:
    \t${nc}$me ${yellow}-e -s
    \t${nc}$me ${yellow}--enable --silent
    \t${blu}Enables HTTPS on the Admin Interface Silently $nc"
}

# Options: interactive, verbose, silent, disable, uninstall
if [[ $# = 0 ]]; then
    main
else
    case "${1}" in
        "*e" | "*enable"        ) enable;;
        "*d" | "*disable"       ) disable;;
        "*i" | "*interactive"   ) interactive;;
        "*v" | "*verbose"       ) verbose;;
        "*s" | "*silent"        ) silent main;;
        "*h" | "*help"          ) help;;
        *                       ) help;;
    esac
fi

# Depreecated.. 
