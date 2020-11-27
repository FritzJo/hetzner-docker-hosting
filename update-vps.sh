#!/bin/bash
SSH_KEY_FILE=./key

echo -n "Initiate a backup first? (y/n)? "
read -r answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    bash /hosting/scripts/backup.sh
fi

if ! command -v ansible-playbook &> /dev/null; then
    echo "Ansible could not be found, running in local mode!"
    bash /hosting/scripts/update.sh
else
    export ANSIBLE_HOST_KEY_CHECKING=False
    ansible-playbook -u root --private-key $SSH_KEY_FILE -i terraform/hosting-instances.ini ansible/playbook-master.yaml
fi
