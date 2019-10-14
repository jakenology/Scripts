#!/bin/bash
## UniFi Controller Backup to Google Drive
# Backup Directory
backup_dir=/usr/lib/unifi/data/backup/autobackup

# Gdrive folder id
folder_id='1o2qfZEVbwTN5aKtRSrKot-SUegznOgvZ'

# Get the latest backup file
latest_backup=$(ls -t $backup_dir/*.unf | head -n1)

# Upload the latest backup file
gdrive upload -p $folder_id $latest_backup
