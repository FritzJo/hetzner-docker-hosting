#!/bin/bash
if [ "$1" = "setup" ]; then
    echo "Initializing Terraform environment"
    cd tofu/ || exit 1 
    tofu init
elif [ "$1" = "create" ]; then
    cd tofu || exit 1
    echo yes | tofu apply -var-file="../custom/terraform.tfvars"
    cd .. || exit 1
elif [ "$1" = "destroy" ]; then
    cd tofu || exit 1
    tofu destroy -var-file="../custom/terraform.tfvars"
    cd .. || exit 1
    rm custom/hosting-instances.ini
elif [ "$1" = "update" ]; then
    export ANSIBLE_HOST_KEY_CHECKING=False
    cd ansible || exit 1
    ansible-playbook master.yaml
    cd .. || exit 1
fi
