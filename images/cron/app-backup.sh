#!/bin/sh
set -e

TIMESTAMP=$(date +%Y%m%dT%H%M%S%z)
START_TIME=$(date +%s)

cd "$HOST_PATH"

if [ "$BACKUP_OPERATION" = "disable" ]; then
    echo "[W] Backups are disabled."
else
    if [ ! -d backups ]; then
        echo "[I] Creating backup directory."
        mkdir backups
    fi

    if [ -d backups/tmp_backup ]; then
        echo "[W] Cleaning up from a previously-failed execution."
        rm -rf backups/tmp_backup
    fi

    echo "[I] Creating working directory."
    mkdir -p backups/tmp_backup

    echo "[I] Backing up MunkiReport database."
    mysqldump --host=db --user=${MYSQL_USER} --password=${MYSQL_PASSWORD} --databases ${MYSQL_DATABASE} > backups/tmp_backup/db.sql

    if [ -f volumes/web/config.php ]; then
        echo "[I] Backing up MunkiReport configuration file."
        cp volumes/web/config.php backups/tmp_backup/config.php
    else
        echo "[E] MunkiReport configuration file does not exist."
        exit 1
    fi

    echo "[I] Compressing backup."
    tar -zcf backups/$TIMESTAMP.tar.gz -C backups/tmp_backup .

    echo "[I] Removing working directory."
    rm -rf backups/tmp_backup

    EXPIRED_BACKUPS=$(ls -1tr backups/*.tar.gz 2>/dev/null | head -n -$BACKUP_RETENTION)
    if [ "$EXPIRED_BACKUPS" ]; then
        echo "[I] Cleaning up expired backup(s):"
        for BACKUP in $EXPIRED_BACKUPS; do
            echo "      $BACKUP"
            rm "$BACKUP"
        done
    fi
fi

END_TIME=$(date +%s)

echo "[I] Script complete. Time elapsed: $((END_TIME-START_TIME)) seconds."
