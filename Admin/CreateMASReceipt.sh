#!/bin/sh
#
# Creates MASReceipts for specific applications.
# Set $1 as the full app name ie, iphoto.app
#
# Geoffrey O’Brien
# Last Modified - 062214
#
# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 1 IF NOT, EXIT.

if [ "$1" == "" ]; then
	echo "Error:  No Application Specified."
	exit 1
fi

mkdir /Applications/$1/Contents/_MASReceipt
touch /Applications/$1/Contents/_MASReceipt/receipt
