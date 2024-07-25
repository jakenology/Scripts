#!/bin/bash
# By JakeNology (Works with Jumpcloud on MBP 2013, just delete the jamf parts)
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
