#!/bin/bash
if [ "$1" = "setup" ]; then
    echo "Initializing Terraform environment"
    cd terraform/ || exit 1 
    terraform init
elif [ "$1" = "create" ]; then
    cd terraform || exit 1
    echo yes | terraform apply -var-file="../custom/terraform.tfvars"
    cd .. || exit 1
elif [ "$1" = "destroy" ]; then
    cd terraform || exit 1
    terraform destroy -var-file="../custom/terraform.tfvars"
    cd .. || exit 1
    rm custom/hosting-instances.ini
elif [ "$1" = "update" ]; then
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
        ansible-playbook -u root --private-key $SSH_KEY_FILE -i custom/hosting-instances.ini ansible/playbook-master.yaml
    fi
fi
