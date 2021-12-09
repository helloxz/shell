#!/bin/bash
#####	name:一键安装node-exporter节点		#####
#####	authro:xiaoz<xiaoz93@outlook.com>	#####
#####	update:2021/12/09					#####

#获取版本号
VERSION=$1
#instance名称
INSTANCE=$2
#用户名、密码
USERNAME_PASSWORD=$3
#安装目录
INSTALL_PATH="/opt/node_exporter"

#安装前准备
depend(){
	if [ -e "/usr/bin/yum" ]
	then
		yum -y install wget
	else
		#更新软件，否则可能make命令无法安装
		apt-get -y update
		apt-get install -y wget
	fi
	#创建目录
	#mkdir -p ${INSTALL_PATH}
}
#下载
download(){
	wget -P /opt http://soft.xiaoz.org/linux/node_exporter-${VERSION}.linux-amd64.tar.gz
	cd /opt && tar -xvf node_exporter-${VERSION}.linux-amd64.tar.gz
	mv node_exporter-${VERSION}.linux-amd64 node_exporter
}

#一些额外的配置
setting(){
	
cat >> $INSTALL_PATH/config.yaml << EOF
basic_auth_users:
  $USERNAME_PASSWORD
EOF

}

#放行端口
release_port(){
	firewall-cmd --zone=public --add-port=29100/tcp --permanent
	firewall-cmd --reload
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
}

#清理工作
clean_work() {
	rm -rf /opt/node_exporter-${VERSION}.linux-amd64.tar.gz
}

depend && download && setting && release_port && reg_systemd
clean_work