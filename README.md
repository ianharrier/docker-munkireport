# docker-munkireport

Dockerized MunkiReport-PHP

### Contents

* [About](#about)
* [How-to guides](#how-to-guides)
    * [Installing](#installing)
    * [Upgrading](#upgrading)
    * [Running a one-time manual backup](#running-a-one-time-manual-backup)
    * [Restoring from a backup](#restoring-from-a-backup)
    * [Uninstalling](#uninstalling)

## About

This repo uses [Docker](https://www.docker.com) and [Docker Compose](https://docs.docker.com/compose/) to automate the deployment of [MunkiReport](https://github.com/munkireport/munkireport-php).

This is more than just a MunkiReport image. Included in this repo is everything you need to get MunkiReport up and running as quickly as possible and a **pre-configured backup and restoration solution**.

## How-to guides

*Note: some of the commands in these guides may require root access to your system. If that is the case, either run the commands while logged in to the root account, or simulate a login to the root account using `sudo -i`. Due to the way environment variables are passed on some systems, typing `sudo` before each command is __not__ a supported method of running the commands in these guides with root access.*

### Installing

1. Ensure the following are installed on your system:

    * [Docker](https://docs.docker.com/engine/installation/)
    * [Docker Compose](https://docs.docker.com/compose/install/) **Warning: [installing as a container](https://docs.docker.com/compose/install/#install-as-a-container) is not supported.**
    * `git`

2. Clone this repo to a location on your system. *Note: in all of the guides on this page, it is assumed the repo is cloned to `/srv/docker/munkireport`.*

    ```shell
    git clone https://github.com/ianharrier/docker-munkireport.git /srv/docker/munkireport
    ```

3. Set the working directory to the root of the repo.

    ```shell
    cd /srv/docker/munkireport
    ```

4. Create the `.env` file using `.env.template` as a template.

    ```shell
    cp .env.template .env
    ```

5. Using a text editor, read the comments in the `.env` file, and make modifications to suit your environment.

    ```shell
    vi .env
    ```

6. Create the `config.php` file using `config.template.php` as a template.

    ```shell
    cp volumes/web/config.template.php volumes/web/config.php
    ```

7. Using a text editor, make modifications to the `config.php` file to suit your environment, using [config_default.php](https://github.com/munkireport/munkireport-php/blob/master/config_default.php) as a reference.

    ```shell
    vi volumes/web/config.php
    ```

8. Start MunkiReport in the background.

    ```shell
    docker-compose up -d
    ```

### Upgrading

1. Set the working directory to the root of the repo.

    ```shell
    cd /srv/docker/munkireport
    ```

2. Remove the current application stack.

    ```shell
    docker-compose down
    ```

3. Pull any changes from the repo.

    ```shell
    git pull
    ```

4. Backup the `.env` file.

    ```shell
    mv .env backups/.env.old
    ```

5. Create a new `.env` file using `.env.template` as a template.

    ```shell
    cp .env.template .env
    ```

6. Using a text editor, modify the new `.env` file. **Warning: it is especially important to use the same database name, username, and password as what exists in `backups/.env.old`.**

    ```shell
    vi .env
    ```

7. Start MunkiReport in the background.

    ```shell
    docker-compose up -d
    ```

8. When all is confirmed working, remove the the `.env.old` file.

    ```shell
    rm backups/.env.old
    ```

### Running a one-time manual backup

1. Set the working directory to the root of the repo.

    ```shell
    cd /srv/docker/munkireport
    ```

2. Run the backup script.

    ```shell
    docker-compose exec backup app-backup
    ```

### Restoring from a backup

**Warning: the restoration process will immediately stop and delete the current production environment. You will not be asked to save any data before the restoration process starts.**

1. Set the working directory to the root of the repo.

    ```shell
    cd /srv/docker/munkireport
    ```

2. Make sure the **backup** container is running. *Note: if the container is already running, you can skip this step, but it will not hurt to run it anyway.*

    ```shell
    docker-compose up -d backup
    ```

3. List the available files in the `backups` directory.

    ```shell
    ls -l backups
    ```

4. Specify a file to restore in the following format:

    ```shell
    docker-compose exec backup app-restore <backup-file-name>
    ```

    For example:

    ```shell
    docker-compose exec backup app-restore 20170501T031500+0000.tar.gz
    ```

### Uninstalling

1. Set the working directory to the root of the repo.

    ```shell
    cd /srv/docker/munkireport
    ```

2. Remove the application stack.

    ```shell
    docker-compose down
    ```

3. Delete the repo. **Warning: this step is optional. If you delete the repo, all of your MunkiReport data, including backups, will be lost.**

    ```shell
    rm -rf /srv/docker/munkireport
    ```
