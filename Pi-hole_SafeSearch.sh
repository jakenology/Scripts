#!/bin/bash
### I MOVED! ###
### https://github.com/jaykepeters/pss ###
### If you see this, you're lucky :) 
### If not, you still are :)
### I will install from the new source for you
if [ $EUID -ne 0 ]; then
    echo 'Error: You must run this script with sudo'
else 
    echo 'I moved! See the comments in this script for more information...'
    echo 'Installing PSS from new repo...'
    curl -sSL https://github.com/jaykepeters/PSS/blob/master/Pi-hole_SafeSearch.sh -O /usr/local/bin/Pi-hole_SafeSearch.sh
    chmod a+x Pi-hole_SafeSearch.sh
fi
