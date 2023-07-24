#!/bin/bash
backup_command="restic -r gs:{{ GCP_Bucket_Name }}:/backups backup /hosting/instances"
init_command="restic -r gs:{{ GCP_Bucket_Name }}:/backups init"
restore_command="restic -r gs:{{ GCP_Bucket_Name }}:/backups restore latest --target /hosting/backup-restore"
view_command="restic -r gs:{{ GCP_Bucket_Name }}:/backups snapshots"

# Check for root
if [ "$EUID" -ne 0 ]
  then echo "Please run this backup script as root"
  exit
fi

# Configuration
export GOOGLE_APPLICATION_CREDENTIALS="/hosting/secrets/gcp-secret.json"
export GOOGLE_PROJECT_ID="{{ GCP_Project_ID }}"
export RESTIC_PASSWORD="{{ GCP_Backup_Password }}"

# Restore last backup
if [ "$1" = "restore" ]; then
  echo "Restoring latest backup to /hosting/backup-restore"
  eval "$restore_command"
  exit 0
fi

# View existing snapshots
if [ "$1" = "view" ]; then
  echo "Showing last snapshots"
  eval "$view_command"
  exit 0
fi

# Backup for instance data + databases
echo "Backup instance data"

if eval "$backup_command"; then
  echo "Backup successful!"
else
  echo "Initializing Repository first"
  eval "$init_command"
  eval "$backup_command"
fi
