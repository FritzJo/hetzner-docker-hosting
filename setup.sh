#!/bin/bash
echo "Initializing Terraform environment"
cd terraform/ || exit 1 
terraform init
