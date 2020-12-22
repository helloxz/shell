#!/bin/bash
#####		CentOS一键同步时间		#####
#####		Author:xiaoz.me			#####
#####		Update:2019-07-27		#####

#安装ntpdate
yum -y install ntpdate
#设置时区
timedatectl set-local-rtc 1
timedatectl set-timezone Asia/Shanghai
#同步时间
ntpdate -u  pool.ntp.org

ntpd=(`which ntpdate`)

#定时任务
echo "*/20 * * * * ${ntpd} pool.ntp.org > /dev/null 2>&1" >> /var/spool/cron/root
systemctl reload crond

echo "同步成功，当前时间:" date