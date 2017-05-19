#!/bin/sh
set -e

# This script modifies itself after successfully preforming tasks, preventing
# the tasks from running every time the container is restarted.
CRONTAB_COMPLETE=false
TIMEZONE_COMPLETE=false

if [ "$CRONTAB_COMPLETE" = "false" ]; then
  echo "[I] Creating cron job."
  echo "$CRON_EXP /usr/local/bin/app-backup" > /var/spool/cron/crontabs/root
  sed -i 's/^CRONTAB_COMPLETE=.*/CRONTAB_COMPLETE=true/g' /usr/local/bin/docker-entrypoint
fi

if [ "$TIMEZONE_COMPLETE" = "false" ]; then
  if [ "$TIMEZONE" ]; then
    echo "[I] Setting the time zone."
    cp "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
    echo "$TIMEZONE" > /etc/timezone
  fi
  sed -i 's/^TIMEZONE_COMPLETE=.*/TIMEZONE_COMPLETE=true/g' /usr/local/bin/docker-entrypoint
fi

echo "[I] Entrypoint tasks complete. Starting crond."
exec "$@"
