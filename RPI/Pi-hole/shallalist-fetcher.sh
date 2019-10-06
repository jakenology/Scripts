#!/bin/bash
## Daily Blocklist Fetcher
## SELECTED LISTS
lists=(
    "searchengines"
)
##
shallaurl='http://www.shallalist.de/Downloads/shallalist.tar.gz'

# Download list package
echo -e 'Status:\t Downloading package'
curl $shallaurl --output /tmp/shallalist.tar.gz

# Extract list package
echo -e 'Status:\t Extracting package'
tar -xvf /tmp/shallalist.tar.gz

# Remove old lists
echo -e 'Status:\t Removing old lists'
rm -rf /var/www/html/shallalist.*
sed -i.bak '/shallalist/d' /etc/pihole/adlists.list

# Extract selected lists
for list in "${lists[@]}"; do
    bl="/tmp/BL/$list/domains"
    url="http://pi.hole/shallalist.$list.txt"
    
    if [ -f "$bl" ]; then
        echo -e "Status:\t Moving blacklist $list to webroot"
        mv $bl /var/www/html/shallalist.$list.txt
        chown www-data:www-data /var/www/html/shallalist.$list.txt

        echo -e "Status:\t Adding blacklist category $list to Pi-hole"
        grep -qxF "$url" /etc/pihole/adlists.list || echo "$url" >> /etc/pihole/adlists.list
    else
        echo -e "Error:\t Category $list does not exist!"
    fi
done

# Remove used files
echo -e 'Status:\t Removing used files'
rm -rf /tmp/shallalist.tar.gz /tmp/BL

# Update gravity
echo -e 'Status:\t Updating gravity'
pihole -g
