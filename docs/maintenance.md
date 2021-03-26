# Maintenance / How to manage the server
## Deploying new Services
WIP

## Restoring backups
If you have accidentally deleted some of your service data or want to recover an older version of a file you can use the automated backup feature for that.

### Restoring the latest backup
This is the most simple case. You can just run the ```backup.sh``` script deployed on your Hetzner instance with the "restore" parameter. This will restore the latest backup to ```/hosting/backup-restore```
```bash
# SSH into your VM and then run the following commands
cd /hosting/scripts
./backup.sh restore
```

### Other scenarios
You can always use the full functionality of [Restic](https://github.com/restic/restic) which is the backup tool used for this project. The full restore documentation is provided [here](https://restic.readthedocs.io/en/latest/050_restore.html)
