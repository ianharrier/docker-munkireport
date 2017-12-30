#!/bin/sh
set -e

if [ "$TIMEZONE" ]; then
    echo "[I] Setting the time zone."
    echo "date.timezone = $TIMEZONE" > /etc/php7/conf.d/timezone.ini
fi

echo "[I] Setting file permissions."
chown root:root config.php
chmod +r config.php

echo "[I] Entrypoint tasks complete. Starting MunkiReport."
exec "$@"
