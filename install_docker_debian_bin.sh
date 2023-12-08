#!/bin/bash
#####		debian 安装Docker二进制版本		#####

DOMAIN=https://soft.xiaoz.org

# 下载二进制
download() {
	wget -P /tmp https://soft.xiaoz.org/linux/debian/containerd.io_1.6.9-1_amd64.deb
	wget -P /tmp https://soft.xiaoz.org/linux/debian/docker-ce_24.0.7-1~debian.11~bullseye_amd64.deb
	wget -P /tmp https://soft.xiaoz.org/linux/debian/docker-ce-cli_24.0.7-1~debian.11~bullseye_amd64.deb
	wget -P /tmp https://soft.xiaoz.org/linux/debian/docker-buildx-plugin_0.11.2-1~debian.11~bullseye_amd64.deb
	wget -P /tmp https://soft.xiaoz.org/linux/debian/docker-compose-plugin_2.6.0~debian-bullseye_amd64.deb
}

install() {
	cd /tmp
	dpkg -i ./containerd.io_*.deb \
	  ./docker-ce_*.deb \
	  ./docker-ce-cli_*.deb \
	  ./docker-buildx-plugin_*.deb \
	  ./docker-compose-plugin_*.deb
	mkdir -p /etc/docker
	touch /etc/docker/daemon.json
	#创建存储目录
	mkdir -p /data/docker-data
	cat <<EOF > /etc/docker/daemon.json
{
    "data-root": "/data/docker-data",
    "storage-driver": "overlay2"
}
EOF

	systemctl start docker
	systemctl enable docker
	#运行一个hello word
	docker run hello-world
	
}

download && install