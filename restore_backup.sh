#!/bin/bash

BACKUP_ROOT=/srv/backup/$1
BACKEND_UPLOAD=/srv/backend/web/uploads

set -e

if [[ ! $1 ]]
then
	echo "Add date parameter for backup: dd-mm-YYYY."
	exit 1

elif [[ ! $1 =~ ^[0-3]{1}[0-9]{1}-[0-1]{1}[0-9]{1}-20[0-9]{2}$ ]]
then 
	echo "Input date parameter is wrong. Example: 31-12-2019"
	exit 1
else
	echo "Start restore on date: $1"
fi


DUMP_NAME=$(basename $BACKUP_ROOT/*sql.*)

if [[ ! -f "$BACKUP_ROOT/$DUMP_NAME" ]]
then
	echo "Stop! No backup in directory: $BACKUP_ROOT/$DUMP_NAME"
	exit 1
else 
	if [[ $DUMP_NAME == *.gz ]]
	then
		gzip -d $BACKUP_ROOT/$DUMP_NAME
		echo "Gzip dump: $DUMP_NAME"

	elif [[ $DUMP_NAME == *.zip ]]
	then
		unzip $BACKUP_ROOT/$DUMP_NAME -d $BACKUP_ROOT
		echo "Unzip dump: "$DUMP_NAME""
	else
		echo "Stop! Dump is not zip or gzip."
         	exit 1
	fi
fi

if [[ ! -f $BACKEND_UPLOAD ]]
then
	mkdir -p $BACKEND_UPLOAD
	echo "Create directory: $BACKEND_UPLOAD"
fi

if [[ -f $BACKEND_UPLOAD/$DUMP_NAME ]]
then
	rm -r $BACKEND_UPLOAD/$DUMP_NAME
	echo "Clear upload directory: $BACKEND_UPLOAD/$DUMP_NAME"
fi

mv $BACKUP_ROOT/$DUMP_NAME $BACKEND_UPLOAD
echo "Done! Dump moved to: $BACKEND_UPLOAD"
exit 0
