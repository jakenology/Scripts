#!/bin/bash
# Install Hyper - v1.0.0
## Set Global Variables
TEMP_DIR=/tmp
ZIP_NAME="temp_download.zip"
APP_NAME="Hyper.app"
USERNAME=$(stat -f%Su /dev/console)
HOME_DIR=$(eval echo "~${username}")
DESTINATION=/Applications

# Determine where to put the files
if [ "$EUID" -ne 0 ]; then
	DESTINATION="$HOME_DIR""$DESTINATION"
fi

# Download the latest version
curl -o $TEMP_DIR/$ZIP_NAME -O -J -L https://releases.hyper.is/download/mac --silent

# Unzip the file
unzip -oqq "$TEMP_DIR/$ZIP_NAME" -d $DESTINATION

# Remove temporary file
rm -rf $TEMP_DIR/$ZIP_NAME