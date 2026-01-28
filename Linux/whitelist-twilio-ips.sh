#!/bin/bash
## JAKENOLOGY
## 01/27/2026
## USE WITH LATEST VERSION OF FREEPBX

# Define Twilio North America Signaling IP Ranges
TWILIO_IPS=(
    "54.172.60.0/30"
    "54.172.60.0/23"
    "54.244.51.0/30"
    "54.171.127.192/30"
    "35.156.191.128/30"
    "54.65.63.192/30"
    "54.169.127.128/30"
    "54.252.254.64/30"
)

echo "Adding Twilio Signaling IPs to the Trusted zone..."

for ip in "${TWILIO_IPS[@]}"
do
    echo "Whitelisting: $ip"
    # Added 'trust' keyword explicitly to satisfy the zone requirement
    fwconsole firewall trust $ip
done

echo "Applying firewall changes..."
fwconsole firewall sync

echo "Verification: The following IPs are now in your Trusted zone:"
fwconsole firewall list trusted
