#!/bin/bash
## List all preference panes and their identifiers
## Can be used to craft configuration profiles
## Copyright 2019 Jayke Peters

## Apple provided
echo "Apple System Preference Panes"
for pane in /System/Library/PreferencePanes/*; do
    echo -e "Preference Pane:\t $pane"
    identifier=$(defaults read $pane/Contents/Info.plist CFBundleIdentifier)
    echo -e "Identifier:\t\t $identifier\n"
done

## User Installed/Third Party
echo "Third Party System Preference Panes"
    DIR=/Library/PreferencePanes
    if [ "$(ls -A $DIR)" ]; then
       for pane in $DIR/*; do
            echo -e "Preference Pane:\t $pane"
            identifier=$(defaults read "$pane/Contents/Info.plist" CFBundleIdentifier)
            echo -e "Identifier:\t\t $identifier\n"
        done
    else
        echo "No user installed preference panes!"
    fi

## There are also preference panes in ~/Library/PreferencePanes as well
## NOTE:     You can use the identifiers to craft a configuration profile to either allow the specified panes, or disallow the panes. 
