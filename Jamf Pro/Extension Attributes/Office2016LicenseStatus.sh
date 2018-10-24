#!/bin/bash
file="/Library/Preferences/com.microsoft.office.licensingV2.plist"
if [ -f "$file" ]; then
	echo "<result>YES</result>"
else
	echo "<result>NO</result>"
fi
