#!/bin/bash
set -e
echo "Start restore..."

BACKUP_ROOT=/srv/backup/$(date '+%d-%m-%Y')
BACKEND_UPLOAD=/srv/backend/web/uploads
DUMP_NAME=db-dump.sql.gz
if [[ ! -f $BACKUP_ROOT/$DUMP_NAME ]];
then
	echo "Stop! No $DUMP_NAME in: $BACKUP_ROOT"
	exit
fi

if [[ -f $BACKUP_ROOT/$DUMP_NAME ]]
then
	sudo gzip -d $BACKUP_ROOT/$DUMP_NAME
	echo "Gzip dump: $DUMP_NAME"
else
	echo "Stop! Dump not zip or gzip."
	exit
fi

if [[ ! -f $BACKEND_UPLOAD ]]
then
	sudo mkdir -p $BACKEND_UPLOAD
	echo "Create directory: $BACKEND_UPLOAD"
fi
sudo mv $BACKUP_ROOT/*.sql $BACKEND_UPLOAD
echo "Done! Dump moved to: $BACKEND_UPLOAD"
exit
