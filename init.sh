#!/bin/bash
#####	新系统初始化	#####

#同步时间
function sync_time() {
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
}

#安装BBR
function insrall_bbr() {
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
	#重启服务器
	reboot
}
sync_time && insrall_bbr