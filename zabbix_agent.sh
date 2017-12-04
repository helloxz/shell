#!/bin/bash
#####		一键安装Zabbix agent		#####
#####		Update:2017-11-30			#####
#####		Author:xiaoz.me				#####

#获取主机名
hostname=$(hostname)
#获取服务器IP
osip=$(curl http://https.tn/ip/myip.php?type=onlyip)

#安装函数
function centos7(){
	rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-1.el7.centos.noarch.rpm
	yum -y install zabbix-agent
	#开机启动
	systemctl enable zabbix-agent.service
}

function centos6(){
	rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/6/x86_64/zabbix-release-3.4-1.el6.noarch.rpm
	yum -y install zabbix-agent
	#开机启动
	chkconfig zabbix-agent on
}

function debian8(){
	wget http://repo.zabbix.com/zabbix/3.4/debian/pool/main/z/zabbix-release/zabbix-release_3.4-1+jessie_all.deb
	dpkg -i zabbix-release_3.4-1+jessie_all.deb
	apt-get update
	apt-get install -y zabbix-agent
}

function debian7(){
	wget http://repo.zabbix.com/zabbix/3.4/debian/pool/main/z/zabbix-release/zabbix-release_3.4-1+wheezy_all.deb
	dpkg -i zabbix-release_3.4-1+wheezy_all.deb
	apt-get update
	apt-get install -y zabbix-agent
}

echo "----------------------------------"
echo "请选择系统："
echo "1) CentOS 7"
echo "2) CentOS 6"
echo "3) Debian 8"
echo "4) Debian 7"
echo "q) 退出"
echo "----------------------------------"
read -p ":" num
case $num in
	1) 
	echo "CentOS 7"
	;;
	2) 
	echo "CentOS 6"
	;;
	3) 
	echo "Debian 8"
	;;
	1) 
	echo "Debian 7"
	;;
	q) 
	exit
	;;
esac