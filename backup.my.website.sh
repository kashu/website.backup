#!/bin/bash
#Author: kashu
#Date: 2014-01-24
#Filename: backup.kashu.org.sh
#Description: Backup my website: http://kashu.org

BAK=/root/backup
LOG=${BAK}/bak.log
DATE=`date +%Y%m%d`
if [ -s "/backup/${DATE}.tar.bz2" -a -s "/backup/${DATE}.sql.bz2" ]; then exit; fi
tar -jcvpf ${BAK}/${DATE}.tar.bz2 /html/kashu.org/ &> /dev/null
test -s ${BAK}/${DATE}.tar.bz2 || { echo "Error:${DATE}.tar.bz2" >> ${LOG} && exit 1; }

mysqldump -uusername -ppassword DB_name > ${BAK}/${DATE}.sql
test -s ${BAK}/${DATE}.sql || { echo "Error:${DATE}.sql" >> ${LOG} && exit 2; }
bzip2 -9 ${BAK}/${DATE}.sql

/root/shell/dropbox_uploader.sh upload ${BAK}/${DATE}*.bz2 /kashu.org
if [ "$?" == 0 ]; then
	echo "${DATE}:OK" >> ${LOG}
else
	echo "${DATE}:Error" >> ${LOG}
fi
