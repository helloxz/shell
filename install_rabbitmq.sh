#!/bin/bash
#####		name:rpm包安装rabbitMQ		#####

#参考教程：https://jingyan.baidu.com/article/c275f6bae21a0ca23c75672d.html
# https://www.rabbitmq.com/install-rpm.html#package-dependencies
# https://www.rabbitmq.com/install-rpm.html#install-erlang
# https://github.com/rabbitmq/erlang-rpm/releases

#安装依赖
function depend(){
	yum -y update
	yum -y install wget curl socat
}

#下载并安装rpm包
function install_rpm(){
	wget https://github.com/rabbitmq/erlang-rpm/releases/download/v23.1.5/erlang-23.1.5-1.el7.x86_64.rpm
	wget https://github.com/rabbitmq/rabbitmq-server/releases/download/v3.8.9/rabbitmq-server-3.8.9-1.el7.noarch.rpm
	rpm -ivh v23.1.5/erlang-23.1.5-1.el7.x86_64.rpm
	rpm -ivh rabbitmq-server-3.8.9-1.el7.noarch.rpm
}

#启动服务并安装插件
function instal_plugins(){
	#启动服务
	systemctl start rabbitmq-server
	systemctl enable rabbitmq-server
	#安装插件
	rabbitmq-plugins enable rabbitmq_management
}

#防火墙放行端口
function pass_firewalld(){
	firewall-cmd --zone=public --add-port=15672/tcp --permanent
	firewall-cmd --reload
}

#执行函数进行安装
depend
install_rpm
instal_plugins
pass_firewalld