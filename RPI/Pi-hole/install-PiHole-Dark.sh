#!/bin/bash
## Check to see if the script is running as root
if [ $EUID -ne 0 ]; then
  echo "$USER" is not root
  exit 0
fi

## Perform the Installation
# Change Directory
cd /var/www/html/

# Download the Script
wget https://raw.githubusercontent.com/lkd70/PiHole-Dark/master/install.sh

# Give script execute permissions
chmod +x install.sh

# Run the script
./install.sh
