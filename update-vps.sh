#!/bin/bash
SSH_KEY_FILE=./key

echo -n "Initiate a backup first? (y/n)? "
read answer
if [ "$answer" != "${answer#[Yy]}" ] ;then
    echo "TODO"
fi

export ANSIBLE_HOST_KEY_CHECKING=False
ansible-playbook -u root --private-key $SSH_KEY_FILE -i terraform/wordpress-instances.ini ansible/playbook-hosting.yaml

