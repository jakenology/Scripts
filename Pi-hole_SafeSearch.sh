#!/bin/bash
### I MOVED! ###
### https://github.com/jakenology/pss ###
### If you see this, you're lucky :) 
### If not, you still are :)
### I will install from the new source for you
pss=/usr/local/bin/Pi-hole_SafeSearch.sh
if [ $EUID -ne 0 ]; then
    echo 'Error: You must run this script with sudo'
else 
    echo 'I moved! See the comments in this script for more information...'
    echo 'Installing PSS from new repo...'
    curl -L 'https://raw.githubusercontent.com/jakenology/PSS/master/Pi-hole_SafeSearch.sh' -o $pss
    chmod a+x $pss
    Pi-hole_SafeSearch.sh "$@"
fi
