#!/bin/bash

# Configuration
export GOOGLE_APPLICATION_CREDENTIALS="/hosting/secrets/gcp-secret.json"
export GOOGLE_PROJECT_ID="{{ GCP_Project_ID }}"
export RESTIC_PASSWORD="{{ GCP_Backup_Password }}"
# Backup for instance data + databases
# restic -r gs:hosting-private-storage:/docker init
echo "Backup instance data"
sudo -E restic -r gs:{{ GCP_Bucket_Name }}:/backups backup /hosting/instances