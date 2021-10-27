#!/bin/bash

# Check for root
if [ "$EUID" -ne 0 ]
  then echo "Please run this backup script as root"
  exit
fi

apply_external_rules () {
    FILENAME=$1
    echo "Processing $FILENAME"
    while read -r line; do
        echo "Validating $line"
        if [[ "$line" =~ ^allow|deny\ [0-9]{1,6}$ ]]
        then
          echo " --> OK!"
          eval "ufw $line"
        else
          echo " --> INVALID!"
        fi
        done < "$FILENAME"
}

echo "Reset rules.."
ufw --force reset > /dev/null

echo "Default deny incoming.."
ufw default deny incoming > /dev/null

echo "Default deny outgoing.."
ufw default deny outgoing > /dev/null

apply_external_rules "/hosting/secrets/ufw-rules.conf"

echo y | ufw enable
