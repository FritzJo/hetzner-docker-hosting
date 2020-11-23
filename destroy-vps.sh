#!/bin/bash
cd terraform || exit 1
terraform destroy
cd .. || exit 1