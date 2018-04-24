#!/bin/bash
# Reset VScode Version 1.0 -- Initial Commit

## Initialize Arrays
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

# Attempt to kill VScode
#for pid in "${pids[@]}"; do
   # kill -9 $pid &
#done

# Remove Preference Files
for item in "${list[@]}"; do
    echo -e 'TASK\t \n' > ~/Library/Logs/reset-vscode.log
    echo removing $item >> ~/Library/Logs/reset-vscode.log
    rm -Rif "$item" >> ~/Library/Logs/reset-vscode.log
done
