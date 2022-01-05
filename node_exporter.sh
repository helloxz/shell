#!/bin/bash
#####	name:一键安装node-exporter节点		#####
#####	authro:xiaoz<xiaoz93@outlook.com>	#####
#####	update:2021/12/09					#####

#获取action
ACTION=$1
#获取版本号
VERSION=$2
#instance名称
#INSTANCE=$2
#用户名、密码
#USERNAME_PASSWORD=$3
#安装目录
INSTALL_PATH="/opt/node_exporter"

#安装前准备
depend(){
	echo "Pre-installation preparation is in progress..."
	if [ -e "/usr/bin/yum" ]
	then
		yum -y install wget curl
	else
		#更新软件，否则可能make命令无法安装
		apt-get -y update
		apt-get install -y wget curl
	fi
	#获取机器IP
	myip=$(curl ipv4.ip.sb)
	#获取INSTANCE名称，如果为空，则获取hostname
	if [[ "$INSTANCE" == "" ]]
	then
		INSTANCE=$(echo $HOSTNAME)_${myip}
	else
		INSTANCE=${HOSTNAME}_${myip}
	fi
}
#下载
download(){
	echo "Ready to download the installation package..."
	wget -P /opt http://soft.xiaoz.org/linux/node_exporter-${VERSION}.linux-amd64.tar.gz
	cd /opt && tar -xvf node_exporter-${VERSION}.linux-amd64.tar.gz
	mv node_exporter-${VERSION}.linux-amd64 node_exporter
}

#一些额外的配置
setting(){
	#设置密码访问
cat >> $INSTALL_PATH/config.yaml << EOF
basic_auth_users:
  $USERNAME_PASSWORD
EOF

}

#放行端口
release_port(){
	echo "Detecting firewall type..."
	#检测防火墙类型
	which firewall-cmd
	if [ $? -eq 0 ]
	then
		firewall_status=$(firewall-cmd --state)
		if [[ "$firewall_status" == "running" ]]
		then
			firewall-cmd --zone=public --add-port=29100/tcp --permanent
			firewall-cmd --reload
		fi
	fi
	which ufw
	if [ $? -eq 0 ]
	then
		ufw allow 29100/tcp
	fi
}


#注册服务并启动
reg_systemd(){
	echo "Registering service..."
echo "[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
ExecStart=${INSTALL_PATH}/node_exporter --web.listen-address=":29100" --web.config=${INSTALL_PATH}/config.yaml

[Install]
WantedBy=default.target" > /etc/systemd/system/node_exporter.service
	#重载服务
	systemctl daemon-reload
	#启动服务
	systemctl start node_exporter.service
	#设置开机自启
	systemctl enable node_exporter.service
}

#安装完成
install_success(){
	echo "----------------------------"
	#推送数据到普罗米修斯以自动注册
	curl -u 'xiaoz:HAKrmCM6' -X POST -d "instance=${INSTANCE}" https://prometheus.rss.ink/api/v1/push_data
	echo "Installation is complete, please visit http://${myip}:29100"
}

#清理工作
clean_work() {
	echo "Cleaning installation packages..."
	rm -rf /opt/node_exporter-${VERSION}.linux-amd64.tar.gz
}

#卸载node_exporter
uninstall(){
	#停止服务
	systemctl stop node_exporter
	systemctl disable node_exporter
	#删除服务
	rm -rf /etc/systemd/system/node_exporter.service
	systemctl daemon-reload
	#删除安装目录
	rm -rf ${INSTALL_PATH}
	echo "----------------------------"
	echo "Uninstall completed."
}

#根据参数一判断执行动作
case $ACTION in
"install")
	depend && download && setting && release_port && reg_systemd && clean_work && install_success
	;;
"uninstall")
	uninstall
	;;
*)
	echo "Parameter error!"
	;;
esac


