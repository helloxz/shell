#!/bin/bash
#####	新系统初始化	#####

#同步时间
function sync_time() {
	echo '正在执行时间同步......'
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
	echo "同步成功，当前时间:" `date`
	sleep 5
}
#修改SSH端口
function change_port() {
	echo '正在修改SSH端口......'
	config_file="/etc/ssh/sshd_config"
	if grep -q "^Port" $config_file;then
	   	sed -i "/^Port/c Port 1993" $config_file
	else
	   echo "Port 1993" >> $config_file
	fi
	systemctl restart sshd
   	firewall-cmd --zone=public --add-port=1993/tcp --permanent
   	firewall-cmd --reload
	echo 'SSH端口修改完毕......'
	sleep 5
}
#安装BBR
function insrall_bbr() {
	echo '正在安装BBR......'
	yum -y install wget
	wget https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
	rpm --import RPM-GPG-KEY-elrepo.org
	rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm

	#升级最新内核
	yum --enablerepo=elrepo-kernel install kernel-ml -y
	#设置最新内核
	grub2-set-default 0

	#写入配置文件
	echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf

	#清理工作
	rm -rf RPM-GPG-KEY-elrepo.org bbr.sh
	echo 'BBR安装完毕，10s后重启...'
	sleep 10
	#重启服务器
	reboot
	sleep 5
}
sync_time
sleep 5
change_port
sleep 5
insrall_bbr