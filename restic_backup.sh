#!/bin/bash

#####	restic备份脚本	#####
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin:/sbin:/usr/local/mysql/bin
export PATH

#导入环境变量
. .env

myip=`curl -s ip.rss.ink`
new_hostname=${HOSTNAME}_${myip}

#安装resitc
install_restic(){
	cd /tmp
	wget https://wget.ovh/linux/restic_0.13.1_linux_amd64
	mv restic_0.13.1_linux_amd64 /usr/bin/restic
	chmod +x /usr/bin/restic
}

#restic备份
restic_backup(){
	export B2_ACCOUNT_ID=${B2_ACCOUNT_ID}
	export B2_ACCOUNT_KEY=${B2_ACCOUNT_KEY}
	#初始化存储
	restic --password-file=./.restic_pass -r b2:${B2_BUCKET_NAME}:/${new_hostname} init
	#备份数据
	for mydir in ${BACKUP_DIRS}
	do
		
		restic --password-file=./.restic_pass ${EXCLUDE_DIRS} -r b2:${B2_BUCKET_NAME}:/${new_hostname} --verbose backup ${mydir}
		sleep 10
	done
}

restic_backup