#!/bin/bash
cd terraform || exit 1
echo yes | terraform apply -var-file="../custom/terraform.tfvars"
cd .. || exit 1