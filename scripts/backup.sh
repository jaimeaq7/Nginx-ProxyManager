#!/bin/bash
source ../.env

# Nombre del backup de la base de datos
DB_BACKUP_NAME=db_backup_$(date +\%Y-\%m-\%d-\%H.\%M.\%S).tar.gz

# Nombre del backup de Nginx
NGINX_BACKUP_NAME=nginx_backup_$(date +\%Y-\%m-\%d-\%H.\%M.\%S).tar.gz

# Respaldar nginx-proxymanager-data
docker run --rm -v nginx-proxymanager-data:/data -v $BACKUP_DIR:/backup alpine tar czf /backup/$NGINX_BACKUP_NAME -C /data .

# Respaldar nginx-proxymanager-mysql
docker run --rm -v nginx-proxymanager-mysql:/data -v $BACKUP_DIR:/backup alpine tar czf /backup/$DB_BACKUP_NAME -C /data .

#Buscamos y borramos backups antiguos a mas de 7 dias
find ${BACKUP_DIR} -type f -mtime +7 -name "${DB_BACKUP_NAME}*" -delete
find ${BACKUP_DIR} -type f -mtime +7 -name "${NGINX_BACKUP_NAME}*" -delete

#Backup S3
aws s3 --region ${REGION} sync --delete ${BACKUP_DIR} ${S3_BUCKET}