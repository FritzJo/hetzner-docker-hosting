#!/bin/bash

# Check for root
if [ "$EUID" -ne 0 ]
  then echo "Please run this backup script as root"
  exit
fi
echo "Reset rules.."
ufw --force reset > /dev/null

echo "Default deny incoming.."
ufw default deny incoming > /dev/null

echo "Default deny outgoing.."
ufw default deny outgoing > /dev/null

echo "Adding SSH.."
ufw allow 22 > /dev/null

echo "Adding DNS.."
ufw allow out dns > /dev/null

echo "Adding Webserver communication.."
ufw allow out http > /dev/null
ufw allow out https > /dev/null

echo "Adding Portainer.."
ufw allow 9000 > /dev/null

echo y | ufw enable
