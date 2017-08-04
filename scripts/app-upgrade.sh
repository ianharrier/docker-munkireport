#!/bin/sh
set -e

START_TIME=$(date +%s)

echo "[I] Shutting down web container."
docker-compose stop web
echo "--------------------------------------------------------------------------------"

echo "[I] Backing up application stack."
docker-compose exec backup app-backup
echo "--------------------------------------------------------------------------------"

echo "[I] Removing currnet application stack."
docker-compose down
echo "--------------------------------------------------------------------------------"

echo "[I] Pulling changes from repo."
git pull
echo "--------------------------------------------------------------------------------"

echo "[I] Updating environment file."
sed -i .bak "s/^MUNKIREPORT_VERSION=.*/MUNKIREPORT_VERSION=$(grep ^MUNKIREPORT_VERSION= .env.template | cut -d = -f 2)/g" .env
echo "--------------------------------------------------------------------------------"

echo "[I] Building new images."
docker-compose build --pull
echo "--------------------------------------------------------------------------------"

echo "[I] Pulling updated database image."
docker-compose pull db
echo "--------------------------------------------------------------------------------"

echo "[I] Creating and starting backup container."
docker-compose up -d backup
echo "--------------------------------------------------------------------------------"

echo "[I] Restoring application stack to most recent backup."
cd backups
LATEST_BACKUP=$(ls -1tr *.tar.gz 2>/dev/null | head -n 1)
cd ..
docker-compose exec backup app-restore $LATEST_BACKUP
echo "--------------------------------------------------------------------------------"

END_TIME=$(date +%s)

echo "[I] Script complete. Time elapsed: $((END_TIME-START_TIME)) seconds."
