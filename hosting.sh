#!/bin/bash
set -euo pipefail

COMMAND="${1:-}"

validate() {
  local errors=0

  if [[ ! -f custom/terraform.tfvars ]]; then
    echo "ERROR: custom/terraform.tfvars not found" >&2
    errors=1
  else
    local token
    token=$(grep -E '^hcloud_token[[:space:]]*=' custom/terraform.tfvars | grep -oP '"\K[^"]+' || true)
    if [[ -z "$token" ]]; then
      echo "ERROR: hcloud_token is empty in custom/terraform.tfvars" >&2
      errors=1
    fi

    if ! grep -qE '^ssh_source_ips[[:space:]]*=' custom/terraform.tfvars; then
      echo "WARNING: ssh_source_ips not set in custom/terraform.tfvars. SSH port 22 will be open to 0.0.0.0/0." >&2
    fi
  fi

  if [[ ! -f custom/ansible-config.yml ]]; then
    echo "ERROR: custom/ansible-config.yml not found" >&2
    errors=1
  fi

  if [[ ! -f custom/hosting-instances.ini ]] && [[ "$COMMAND" != "create" ]]; then
    echo "WARNING: custom/hosting-instances.ini not found. Run 'create' first." >&2
  fi

  if command -v tofu &>/dev/null; then
    :  # tofu is available
  elif command -v terraform &>/dev/null; then
    :  # terraform is available
  else
    echo "ERROR: neither tofu nor terraform found in PATH" >&2
    errors=1
  fi

  if ! command -v ansible-playbook &>/dev/null; then
    echo "ERROR: ansible-playbook not found in PATH" >&2
    errors=1
  fi

  if [[ $errors -gt 0 ]]; then
    echo "Validation failed with $errors error(s)." >&2
    exit 1
  fi
  echo "Validation passed."
}

case "$COMMAND" in
  check)
    validate
    ;;
  setup)
    echo "Initializing OpenTofu environment"
    cd tofu
    tofu init
    ;;
  create)
    validate
    cd tofu
    tofu apply -var-file="../custom/terraform.tfvars"
    ;;
  destroy)
    cd tofu
    tofu destroy -var-file="../custom/terraform.tfvars"
    rm -f ../custom/hosting-instances.ini
    ;;
  update)
    validate
    export ANSIBLE_HOST_KEY_CHECKING=False
    cd ansible
    ansible-playbook -i ../custom/hosting-instances.ini master.yaml
    ;;
  *)
    echo "Usage: $0 {check|setup|create|destroy|update}" >&2
    exit 1
    ;;
esac