#!/bin/sh
set -e

# This script modifies itself after successfully preforming tasks, preventing
# the tasks from running every time the container is restarted.
TIMEZONE_COMPLETE=false

if [ "$TIMEZONE_COMPLETE" = "false" ]; then
    if [ "$TIMEZONE" ]; then
        echo "[I] Setting the time zone."
        echo "date.timezone = $TIMEZONE" > /etc/php7/conf.d/timezone.ini
    fi
    sed -i 's/^TIMEZONE_COMPLETE=.*/TIMEZONE_COMPLETE=true/g' /usr/local/bin/docker-entrypoint
fi

echo "[I] Entrypoint tasks complete. Starting MunkiReport."
exec "$@"
