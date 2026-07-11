#!/bin/bash
set -euo pipefail

COMMAND="${1:-}"

case "$COMMAND" in
  setup)
    echo "Initializing OpenTofu environment"
    cd tofu
    tofu init
    ;;
  create)
    cd tofu
    tofu apply -var-file="../custom/terraform.tfvars"
    ;;
  destroy)
    cd tofu
    tofu destroy -var-file="../custom/terraform.tfvars"
    rm -f ../custom/hosting-instances.ini
    ;;
  update)
    export ANSIBLE_HOST_KEY_CHECKING=False
    cd ansible
    ansible-playbook master.yaml
    ;;
  *)
    echo "Usage: $0 {setup|create|destroy|update}" >&2
    exit 1
    ;;
esac
