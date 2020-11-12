echo "Reset rules.."
sudo ufw --force reset > /dev/null

echo "Default deny incoming.."
sudo ufw default deny incoming > /dev/null

echo "Default deny outgoing.."
sudo ufw default deny outgoing > /dev/null

echo "Adding SSH.."
sudo ufw allow 22 > /dev/null

echo "Adding Webserver communication.."
sudo ufw allow 80 > /dev/null
sudo ufw allow 443 > /dev/null

# Allow Portainer
sudo ufw allow 9000 > /dev/null

# Allow Filebrowser
sudo ufw allow 9001 > /dev/null

# Allow PHPMyAdmin
sudo ufw allow 9002 > /dev/null