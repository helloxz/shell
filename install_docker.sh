#!/bin/bash
#####		CentOS 7安装Docker		#####

cd
mkdir temp
cd temp

#下载
wget https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.3.9-3.1.el7.x86_64.rpm
wget https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-19.03.9-3.el7.x86_64.rpm
wget https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-cli-19.03.9-3.el7.x86_64.rpm

#安装
yum -y install containerd.io-1.3.9-3.1.el7.x86_64.rpm
yum -y install docker-ce-19.03.9-3.el7.x86_64.rpm
yum -y install docker-ce-cli-19.03.9-3.el7.x86_64.rpm

#启动docker
systemctl start docker
#开机启动
systemctl enable docker

echo '----------------------------------------'

#运行一个hello word
docker run hello-world