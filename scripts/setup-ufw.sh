#!/bin/bash

echo "Reset rules.."
sudo ufw --force reset > /dev/null

echo "Default deny incoming.."
sudo ufw default deny incoming > /dev/null

echo "Default deny outgoing.."
sudo ufw default deny outgoing > /dev/null

echo "Adding SSH.."
sudo ufw allow 22 > /dev/null

echo "Adding DNS.."
sudo ufw allow out dns > /dev/null

echo "Adding Webserver communication.."
sudo ufw allow out http > /dev/null
sudo ufw allow out https > /dev/null

# Allow Portainer
sudo ufw allow 9000 > /dev/null

echo y | sudo ufw enable

