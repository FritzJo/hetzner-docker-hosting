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
        echo "ufw $line"
        eval "$(ufw "$line")"
        done < "$FILENAME"
}

echo "Reset rules.."
ufw --force reset > /dev/null

echo "Default deny incoming.."
ufw default deny incoming > /dev/null

echo "Default deny outgoing.."
ufw default deny outgoing > /dev/null

apply_external_rules "../ansible/security/ufw-rules.conf"

echo y | ufw enable
