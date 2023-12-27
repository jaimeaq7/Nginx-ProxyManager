#!/bin/bash
source ../.env

# Restaurar nginx-proxymanager-data
docker run --rm -v nginx-proxymanager-data:/data -v $BACKUP_DIR:/backup alpine tar xzf /backup/$NGINX_BACKUP_NAME -C /data

# Restaurar nginx-proxymanager-mysql
docker run --rm -v nginx-proxymanager-mysql:/data -v $BACKUP_DIR:/backup alpine tar xzf /backup/$DB_BACKUP_NAME -C /data