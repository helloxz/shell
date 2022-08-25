#!/bin/bash
#####		debian 安装Docker		#####

#准备工作
preparation(){
	#移除原有的服务
	apt-get -y remove docker docker-engine docker.io containerd runc
	#更新软件包
	apt-get update
	#安装必要的依赖
	apt-get -y install ca-certificates curl gnupg lsb-release
	#添加官方密钥
	mkdir -p /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	#设置存储库
	echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
}

#安装docker
install_docker(){
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
	apt-get update
	apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
	#启动docker
	systemctl start docker
	systemctl enable docker
	#运行一个hello word
	docker run hello-world
}

#安装docker composer
install_composer(){
	curl -SL https://github.com/docker/compose/releases/download/v2.7.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
	ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
	chmod +x /usr/local/bin/docker-compose
	docker-compose -v
}

preparation && install_docker && install_composer