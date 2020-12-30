#!/bin/bash
#####		CentOS 7安装Docker		#####

function install_docker(){
	cd
	mkdir temp
	cd temp

	#下载
	wget https://download.docker.com/linux/centos/7/x86_64/stable/Packages/containerd.io-1.3.9-3.1.el7.x86_64.rpm
	wget https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-19.03.9-3.el7.x86_64.rpm
	wget https://download.docker.com/linux/centos/7/x86_64/stable/Packages/docker-ce-cli-19.03.9-3.el7.x86_64.rpm

	#安装
	yum -y install containerd.io-1.3.9-3.1.el7.x86_64.rpm
	yum -y install docker-ce-cli-19.03.9-3.el7.x86_64.rpm
	yum -y install docker-ce-19.03.9-3.el7.x86_64.rpm
	#cd && rm -rf temp
}

#配置存储目录
function set_storage() {
	useradd -g docker docker
	mkdir -p /etc/docker
	#创建配置文件
	touch /etc/docker/daemon.json
	#创建存储目录
	mkdir -p /data/docker-data
	chown -R docker:docker /data/docker-data
cat <<EOF > /etc/docker/daemon.json
{
    "data-root": "/data/docker-data",
    "storage-driver": "overlay2"
}
EOF
}
#install systemc
function install_systemd() {
	cd && cd temp
	wget -O docker.service https://raw.githubusercontent.com/moby/moby/master/contrib/init/systemd/docker.service.rpm
	mv docker.service /etc/systemd/system
	#sed -i 's/dockerd/docker/g' /etc/systemd/system/docker.service
	systemctl daemon-reload
	systemctl start docker
	systemctl enable docker
}

#清理工作
function clean_temp() {
	cd && rm -rf temp
}

#测试运行
function test_run() {
	systemctl daemon-reload
	systemctl start docker
	systemctl enable docker
	#运行一个hello word
	docker run hello-world
}

install_docker
set_storage
#install_systemd
clean_temp
test_run
