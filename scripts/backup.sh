#!/bin/bash
backup_command="restic -r gs:{{ GCP_Bucket_Name }}:/backups backup /hosting/instances"
backup_init_command="restic -r gs:{{ GCP_Bucket_Name }}:/backups init"

# Check for root
if [ "$EUID" -ne 0 ]
  then echo "Please run this backup script as root"
  exit
fi


# Configuration
export GOOGLE_APPLICATION_CREDENTIALS="/hosting/secrets/gcp-secret.json"
export GOOGLE_PROJECT_ID="{{ GCP_Project_ID }}"
export RESTIC_PASSWORD="{{ GCP_Backup_Password }}"
# Backup for instance data + databases
# restic -r gs:hosting-private-storage:/docker init
echo "Backup instance data"

if eval "$backup_command"; then
  echo "Backup successful!"
else
  echo "Initializing Repository first"
  eval "$backup_init_command"
  eval "$backup_command"
fi
