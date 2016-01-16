#!/bin/bash
#Author: kashu
#Date: 2014-01-24
#Filename: backup.kashu.org.sh
#Description: Backup my website: http://kashu.org

BAK=/root/backup
LOG=${BAK}/bak.log
if [ -s "/backup/`date +%Y%m%d`.tar.bz2" -a -s "/backup/`date +%Y%m%d`.sql.bz2" ]; then exit; fi
tar -jcvpf ${BAK}/`date +%Y%m%d`.tar.bz2 /html/kashu.org/ &> /dev/null
test -s ${BAK}/`date +%Y%m%d`.tar.bz2 || { echo "Error:`date +%Y%m%d`.tar.bz2" >> ${BAK}/bak.log && exit 1; }

mysqldump -uroot -ppassword DB_name > ${BAK}/`date +%Y%m%d`.sql
test -s ${BAK}/`date +%Y%m%d`.sql || { echo "Error:`date +%Y%m%d`.sql" >> ${BAK}/bak.log && exit 2; }
bzip2 -9 ${BAK}/`date +%Y%m%d`.sql

/root/shell/dropbox_uploader.sh upload ${BAK}/`date +%Y%m%d`*.bz2 /kashu.org
if [ "$?" == 0 ]; then
	echo "`date +%Y%m%d`:OK" >> ${LOG}
else
	echo "`date +%Y%m%d`:Error" >> ${LOG}
fi
