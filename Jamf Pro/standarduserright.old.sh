#!/bin/sh
# This must be set to if you are going to allow non-admin access to any of the preference panes.
/usr/bin/security authorizationdb read  system.preferences > /tmp/system.preferences.plist
/usr/bin/defaults write /tmp/system.preferences.plist group everyone
/usr/bin/security authorizationdb write system.preferences < /tmp/system.preferences.plist
#
# enable non-admin access to the energy saver prefs
/usr/bin/security authorizationdb read  system.preferences.energysaver > /tmp/system.preferences.energysaver.plist
/usr/bin/defaults write /tmp/system.preferences.energysaver.plist group everyone
/usr/bin/security authorizationdb write system.preferences.energysaver < /tmp/system.preferences.energysaver.plist
#
# enable non-admin access to the printing prefs
/usr/bin/security authorizationdb read  system.preferences.printing > /tmp/system.preferences.printing.plist
/usr/bin/defaults write /tmp/system.preferences.printing.plist group everyone
/usr/bin/security authorizationdb write system.preferences.printing < /tmp/system.preferences.printing.plist
# You must also add everyone to the lpadmin group
/usr/sbin/dseditgroup -o edit -n /Local/Default -a "everyone" -t group lpadmin
