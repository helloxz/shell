#!/bin/bash
#####	name:debian初始化脚本	#####
#####	author:xiaoz			#####
#####	date:2022/08/18			#####

#获取SSH端口
ssh_port=$1

#初始化软件
init_soft(){
	echo '--------------------------------------------------------------';
	echo 'Install curl/wget and firewalld.'
	echo '--------------------------------------------------------------';
	#更新软件
	apt-get update
	#安装必要软件
	apt-get -y install curl wget
	apt-get -y install firewalld
	#启动firewalld
	systemctl start firewalld && systemctl enable firewalld
	#放行常见端口
	firewall-cmd --zone=public --add-port=80/tcp --permanent
	firewall-cmd --zone=public --add-port=443/tcp --permanent
	firewall-cmd --reload
}

#初始化SSH配置
#修改端口和允许root登录
init_ssh(){
	echo '--------------------------------------------------------------';
	echo 'Modifying SSH port.'
	echo '--------------------------------------------------------------';
	#先放行端口
	firewall-cmd --zone=public --add-port=${ssh_port}/tcp --permanent
	firewall-cmd --reload

	#修改ssh配置文件
	#修改SSH端口
	echo "Port ${ssh_port}" >> /etc/ssh/sshd_config
	#允许root登录
	echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

	#重启SSH服务
	systemctl restart sshd
}

#初始化时区
init_timezone(){
	echo '--------------------------------------------------------------';
	echo 'Setting time zone.'
	echo '--------------------------------------------------------------';
	#设置时区为上海
	timedatectl set-timezone Asia/Shanghai
	#同步时间
	apt-get install ntpdate
	ntp_path=$(which ntpdate)

	#写入定时任务
	echo "${ntp_path} -u pool.ntp.org" >> /var/spool/cron/crontabs/root
	#重载定时任务
	/etc/init.d/cron reload
}

#设置虚拟内存，如果存在虚拟内存，则不设置
set_swap() {
	echo '--------------------------------------------------------------';
	echo 'Setting swap.'
	echo '--------------------------------------------------------------';
	curl -s "https://raw.githubusercontent.com/helloxz/shell/master/set_swap.sh" | bash
}

#开启BBR
enable_bbr(){
	echo '--------------------------------------------------------------';
	echo 'Enabling BBR.'
	echo '--------------------------------------------------------------';
	#写入配置文件
	echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
	echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf

	#使内核参数生效
	sysctl -p
}

#修改默认的描述符限制
change_ulimit() {
	echo '--------------------------------------------------------------';
	echo 'Modifying ulimit.'
	echo '--------------------------------------------------------------';
	echo 'fs.file-max = 65535' >> /etc/sysctl.conf
	echo '* soft nofile 65535' >> /etc/security/limits.conf
	echo '* hard nofile 65535' >> /etc/security/limits.conf
	echo 'ulimit -SHn 65535' >> /etc/profile

	#使内核参数生效
	sysctl -p
}

#调用函数执行
init_soft && init_ssh && init_timezone && set_swap && enable_bbr && change_ulimit