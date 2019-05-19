#!/bin/bash
#####		一键安装Zabbix agent		#####
#####		Update:2019-05-19			#####
#####		Author:xiaoz.me				#####

#获取主机名
hostname=$(hostname)
#获取服务器IP
osip=$(curl https://api.ttt.sh/ip/qqwry/?type=ip)
#配置文件
zabbix_config="/etc/zabbix/zabbix_agentd.conf"

#配置zabbix agent
function setting(){
	read -p "输入Zabbix server IP：" serverip
	#备份配置
	cp /etc/zabbix/zabbix_agentd.conf /etc/zabbix/zabbix_agentd.conf.bak
	#设置Server name
	sed -i "s/Hostname=Zabbix server/Hostname=$1/g" ${zabbix_config}
	#设置连接IP
	sed -i "s/# SourceIP=/SourceIP=$2/g" ${zabbix_config}
	#设置Server IP
	sed -i "s/Server=127.0.0.1/Server=${serverip}/g" ${zabbix_config}
	
	echo "#####		设置成功		#####"
	echo "Server IP:${serverip}"
	echo "Agent:$2:10050"
	echo "###############################"
}

#自动放行端口
function chk_firewall() {
	if [ -e "/etc/sysconfig/iptables" ]
	then
		iptables -I INPUT -p tcp --dport 10050 -j ACCEPT
		service iptables save
		service iptables restart
	else
		firewall-cmd --zone=public --add-port=10050/tcp --permanent 
		firewall-cmd --reload
	fi
}

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

function zabbix4(){
	rpm -ivh http://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
	yum -y install zabbix-agent
	#开机启动
	systemctl enable zabbix-agent.service
}

echo "----------------------------------"
echo "请选择系统："
echo "1) CentOS 7(Zabbix agent v3.4)"
echo "2) CentOS 6"
echo "3) Debian 8"
echo "4) Debian 7"
echo "5) CentOS 7(Zabbix agent v4.0)"
echo "q) 退出"
echo "----------------------------------"
read -p ":" num
case $num in
	1)
		#安装
		centos7
		#设置
		setting $hostname $osip
		#放行端口
		chk_firewall
		#启动服务
		systemctl start zabbix-agent.service
	;;
	2) 
		centos6
		setting $hostname $osip
		#放行端口
		chk_firewall
		service zabbix-agent start
	;;
	3) 
	echo "Debian 8"
	;;
	4) 
	echo "Debian 7"
	;;
	5)
		zabbix4
		#设置
		setting $hostname $osip
		#放行端口
		chk_firewall
		#启动服务
		systemctl start zabbix-agent.service
	;;
	q) 
	exit
	;;
esac