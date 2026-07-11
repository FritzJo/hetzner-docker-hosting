#!/bin/bash
set -euo pipefail

readonly BUCKET="{{ GCP_Bucket_Name }}"
readonly BACKUP_TARGET="/hosting/instances"
readonly RESTORE_TARGET="/hosting/backup-restore"

backup_command="restic -r gs:${BUCKET}:/backups backup ${BACKUP_TARGET}"
init_command="restic -r gs:${BUCKET}:/backups init"
restore_command="restic -r gs:${BUCKET}:/backups restore latest --target ${RESTORE_TARGET}"
view_command="restic -r gs:${BUCKET}:/backups snapshots"

if [ "$EUID" -ne 0 ]; then
  echo "Please run this backup script as root" >&2
  exit 1
fi

export GOOGLE_APPLICATION_CREDENTIALS="/hosting/secrets/gcp-secret.json"
export GOOGLE_PROJECT_ID="{{ GCP_Project_ID }}"
export RESTIC_PASSWORD="{{ GCP_Backup_Password }}"

case "${1:-}" in
  restore)
    echo "Restoring latest backup to ${RESTORE_TARGET}"
    $restore_command
    ;;
  view)
    echo "Showing existing snapshots"
    $view_command
    ;;
  "")
    echo "Backing up instance data"
    if ! $backup_command; then
      echo "Initializing repository"
      $init_command
      $backup_command
    fi
    ;;
  *)
    echo "Usage: $0 {restore|view}" >&2
    exit 1
    ;;
esac
