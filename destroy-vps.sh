#!/bin/bash
cd terraform || exit 1
terraform destroy -var-file="../custom/terraform.tfvars"
cd .. || exit 1