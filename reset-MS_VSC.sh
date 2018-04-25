#!/bin/bash
## Reset MS VSC (Mac) - v1.0.2
## MIT License 
## Copyright 2018 Jayke Peters.

## Quick Execution
# curl -fkl https://raw.githubusercontent.com/jaykepeters/Scripts/master/reset-MS_VSC.sh | sh

## Set Global Variables
version="1.0.2"

## Declare Arrays
pids=($(pgrep Code))
list=(
~/Library/Preferences/com.microsoft.VSCode.helper.plist 
~/Library/Preferences/com.microsoft.VSCode.plist 
~/Library/Caches/com.microsoft.VSCode
~/Library/Caches/com.microsoft.VSCode.ShipIt/
~/Library/Application\ Support/Code
~/Library/Saved\ Application\ State/com.microsoft.VSCode.savedState/
~/.vscode/
   )

## THIS IS WHERE ALL THE FUNCTIONS SHALL GO; DO NOT MODIFY BEYOND THIS POINT!!!
# Attempt to Kill Visual Studio Code
killapp() {
    for pid in "${pids[@]}"; do
        kill -9 $pid > /dev/null
    done    
}

# Iterate and remove all app files... (except for a few)
removefiles() {
for item in "${list[@]}"; do
    echo -e 'TASK\t \n' > ~/Library/Logs/Library/Logs/reset-vscode.log
    echo removing $item >> ~/Library/Logs/reset-vscode.log
    rm -Rif "$item" >> ~/Library/Logs/reset-vscode.log
done
}

version() {
    echo -e 'VERSION:\t' $version
}

main() {
    killapp &
    removefiles
}

## Check for USER Input
if [[ $# = 0 ]]; then
    main
else
    while [[ $# > 0 ]]; do
        case "$1" in
            *Version|*version|*V|*v)
            version
            ;;
        esac
        shift
        done
fi
