#!/bin/bash
## MailToOutlook
pkg="https://macadmins.software/tools/MailToOutlook.pkg"
filename=/tmp/m2o.pkg
identifier="net.jetpaq.MailToOutlook"

# Did we already install the package?
pkgutil --pkgs | grep -q $identifier && exit 0

# Download and install the package
curl -o $filename $pkg
installer -pkg $filename -target /
rm -rf $filename
