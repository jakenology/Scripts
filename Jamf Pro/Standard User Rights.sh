#!/bin/bash
# By Jayke Peters (Works with Jumpcloud on MBP 2013, just delete the jamf parts)
# Taken from https://www.jamf.com/jamf-nation/discussions/22854/managing-the-authorization-database
/usr/bin/security authorizationdb write system.preferences allow 
/usr/bin/security authorizationdb write system.preferences.datetime allow
/usr/bin/security authorizationdb write system.preferences.network allow
/usr/bin/security authorizationdb write system.services.systemconfiguration.network allow
/usr/bin/security authorizationdb write system.preferences.printing allow
/usr/bin/security authorizationdb write system.print.operator allow
/usr/sbin/dseditgroup -o edit -n /Local/Default -a everyone -t group lpadmin
/usr/sbin/dseditgroup -o edit -n /Local/Default -a everyone -t group _lpadmin 
/usr/sbin/dseditgroup -o edit -n /Local/Default -a 'Domain Users' -t group lpadmin 

# Kill The Following Applications
for app in "System Preferences"
do
	# Search running processes and find ".app" bundle
	kill -9 $(pgrep -f "$app.app" | head -n 1)

	# Exact Process Name (user renamed app or not)
	# Found in app/Contents/Info.plist under CFBundleExecutable
	# plutil -convert xml1 [path to Info.plist] (binary to xml)
	# Open in text editor and find CFBundleExecutable
	# Or you can go in activity monitor and check process name
	pkill "$app"
done

# This never happened (Do you want this policy to display as run in JSS and Self Service?)
#nohup jamf flushPolicyHistory "Standard User Rights" &>/dev/null

exit 0
