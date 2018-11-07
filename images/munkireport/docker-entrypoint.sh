#!/bin/sh
set -e

if [ "$TIMEZONE" ]; then
    echo "[I] Setting the time zone."
    echo "date.timezone = $TIMEZONE" > /etc/php7/conf.d/timezone.ini
fi

echo "[I] Waiting for MySQL container to complete initialization tasks."
DB_READY=false
while [ "$DB_READY" = "false" ]; do
    sleep 1
    nc -z db 3306 &>/dev/null && DB_READY=true || DB_READY=false
done

echo "[I] Migrating the database."
php database/migrate.php

echo "[I] Setting file permissions."
chown root:root config.php
chmod +r config.php

echo "[I] Entrypoint tasks complete. Starting MunkiReport."
exec "$@"
