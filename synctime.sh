#!/bin/bash
#####		CentOS一键同步时间		#####
#####		Author:xiaoz.me			#####
#####		Update:2018-01-19		#####

#放行端口
sed -i "/udp -j DROP/i\-A OUTPUT -p udp -m udp --dport 123 -j ACCEPT" /etc/sysconfig/iptables
service iptables restart
#同步时间
ntpdate -u  pool.ntp.org

ntpd=(`which ntpdate`)

#定时任务
echo "*/20 * * * * ${ntpd} pool.ntp.org > /dev/null 2>&1" >> /var/spool/cron/root
service crond reload

echo "同步成功，当前时间:" date 