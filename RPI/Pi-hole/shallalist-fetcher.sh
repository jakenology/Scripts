#!/bin/bash
## Daily Blocklist Fetcher
## SELECTED LISTS
if [ -f '/etc/shallalists.txt' ]; then
    lists=($(cat /etc/shallalists.txt))
else
    echo -e 'Error:\t No config file!'
    exit 1
fi
shallaurl='http://www.shallalist.de/Downloads/shallalist.tar.gz'
url='http://pi.hole/shallalist.txt'
blocklist=/var/www/html/shallalist.txt

# Download list package
echo -e 'Status:\t Downloading package'
curl $shallaurl --output /tmp/shallalist.tar.gz --silent

# Extract list package
echo -e 'Status:\t Extracting package'
tar -xvf /tmp/shallalist.tar.gz > /dev/null 2>&1

# Remove old lists
echo -e 'Status:\t Removing old list'
rm -rf $blocklist > /dev/null 2>&1
sed -i.bak '/shallalist/d' /etc/pihole/adlists.list

# Extract selected lists
for list in "${lists[@]}"; do
    bl=/tmp/BL/$list/domains
    
    if [ -f "$bl" ]; then
        echo -e "Status:\t Adding category $list to master"
        cat $bl >> $blocklist
    else
        echo -e "Error:\t Category $list does not exist!"
    fi
done

# Add list to Pi-hole
echo -e 'Status:\t Adding consolidated list to Pi-hole'
grep -qxF "$url" /etc/pihole/adlists.list || echo "$url" >> /etc/pihole/adlists.list
chown www-data:www-data $blocklist

# Remove used files
echo -e 'Status:\t Removing used files'
rm -rf /tmp/shallalist.tar.gz /tmp/BL > /dev/null 2>&1

# Update gravity
echo -e 'Status:\t Updating gravity'
pihole -g > /dev/null 2>&1
