#!/bin/bash
set -euo pipefail

DEPLOYMENT_ROOT="/hosting/instances"

apt-get update
apt-get upgrade -y
apt-get autoremove -y

cd "$DEPLOYMENT_ROOT"

shopt -s nullglob
for dir in */; do
    dir="${dir%/}"
    echo "Updating: $dir"
    cd "$dir"
    docker compose down
    docker compose pull
    docker compose up -d
    cd "$DEPLOYMENT_ROOT"
done

echo "Cleaning up old Docker images"
docker image prune -af

echo "Done! Consider rebooting the system"