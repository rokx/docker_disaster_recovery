#!/bin/bash

#Script to sync forum data to remote location

# docker image: https://hub.docker.com/r/bitnami/phpbb/

# data folder: /docker/phpbb-data (inside a folder for database and one for phpbb)
# running docker containers with compose script: phpbb_phpbb_1 and phpbb_mariadb_1

# user backupuser has rights to manage docker container and has sudo rights on remote server without password for rsync command (keeping owner and group ids)
# visudo on remote -> backupuser            ALL=(ALL)       NOPASSWD: /bin/rsync

# Stop remote docker containers
su - backupuser -c "ssh remote_host docker stop phpbb_phpbb_1"
su - backupuser -c "ssh remote_host docker stop phpbb_mariadb_1"

# Stop local docker containers
docker stop phpbb_phpbb_1
docker stop phpbb_mariadb_1

# Sync data folder
su - backupuser -c "rsync -e ssh --rsync-path=\"sudo rsync\" -aAXSHPr --numeric-ids --delete /docker/phpbb-data/ backupuser@remote_host:/docker/phpbb-data"

# Start local docker containers
docker start phpbb_mariadb_1
docker start phpbb_phpbb_1

# Start remote docker containers
su - backupuser -c "ssh remote_host docker start phpbb_mariadb_1"
su - backupuser -c "ssh remote_host docker start phpbb_phpbb_1"
