#!/bin/bash
set -euo pipefail

if [ "$EUID" -ne 0 ]; then
  echo "Please run this script as root" >&2
  exit 1
fi

apply_external_rules() {
  local filename="$1"
  echo "Processing $filename"
  while read -r line; do
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    echo "Validating: $line"
    if [[ "$line" =~ ^(allow|deny)\ (in|out\ on\ [a-z0-9]+)?\ ?[0-9]{1,5}(\/[a-z]+)? ]]; then
      echo "  -> OK"
      ufw "$line"
    else
      echo "  -> INVALID (skipped)"
    fi
  done < "$filename"
}

ufw --force reset > /dev/null 2>&1
ufw default deny incoming > /dev/null 2>&1
ufw default deny outgoing > /dev/null 2>&1

apply_external_rules "/hosting/secrets/ufw-rules.conf"

ufw --force enable > /dev/null 2>&1