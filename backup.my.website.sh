#!/bin/bash
#Author: kashu
#Date: 2018-01-21
#Filename: website.backup.sh
#Description: Backup my website and upload to dropbox.com

BAK=/root/backup
LOG=${BAK}/bak.log
DATE=`date +%Y%m%d`
if [ -s "/backup/${DATE}.tar.xz" -a -s "/backup/${DATE}.sql.xz" ]; then exit; fi
tar -Jcvpf ${BAK}/${DATE}.tar.xz /var/www/html/kashu/ &> /dev/null
test -s ${BAK}/${DATE}.tar.xz || { echo "Error:${DATE}.tar.xz" >> ${LOG} && exit 1; }

mysqldump -uusername -ppassword database_name > ${BAK}/${DATE}.sql
test -s ${BAK}/${DATE}.sql || { echo "Error:${DATE}.sql" >> ${LOG} && exit 2; }
xz -z9 ${BAK}/${DATE}.sql

/root/dropbox_uploader.sh upload ${BAK}/${DATE}*.xz /kashu
if [ "$?" == 0 ]; then
	echo "${DATE}:OK" >> ${LOG}
else
	echo "${DATE}:Error" >> ${LOG}
fi
