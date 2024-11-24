#!/bin/bash
#####	name:debian初始化脚本	#####
#####	author:xiaoz			#####
#####	date:2022/08/18			#####

#获取SSH端口
ssh_port=$1

#初始化软件
init_soft(){
	echo '--------------------------------------------------------------';
	echo 'Install curl/wget and ufw.'
	echo '--------------------------------------------------------------';
	#更新软件
	apt-get update
	#使用nftables
	#update-alternatives --set iptables /usr/sbin/iptables-nft
	#update-alternatives --set ip6tables /usr/sbin/ip6tables-nft
	#update-alternatives --set arptables /usr/sbin/arptables-nft
	#update-alternatives --set ebtables /usr/sbin/ebtables-nft


	#安装必要软件
	apt-get -y install curl wget ufw net-tools
	#apt-get -y install firewalld
	#启动firewalld
	#systemctl start firewalld && systemctl enable firewalld
	
	#FirewallBackend # Selects the firewall backend implementation. # Choices are: # - nftables (default) # - iptables (iptables, ip6tables, ebtables and ipset) FirewallBackend=iptables
	#针对上面的错误，需要将iptables更换为nftables
	#sed -i "s/FirewallBackend=iptables/FirewallBackend=nftables/g" /etc/firewalld/firewalld.conf
	
	#放行常见端口
	ufw allow 80
	ufw allow 443
	ufw allow 22

	ufw --force enable
	systemctl enable ufw
}

#初始化SSH配置
#修改端口和允许root登录
init_ssh(){
	echo '--------------------------------------------------------------';
	echo 'Modifying SSH port.'
	echo '--------------------------------------------------------------';
	#先放行端口
	ufw allow ${ssh_port}

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

    apt-get install -y cron

    #安装 chrony 或 systemd-timesyncd 以替代 ntpdate
    if apt-get install -y chrony; then
        systemctl enable chrony
        systemctl start chrony
        chronyc -a 'burst 4/4'
    else
        apt-get install -y systemd-timesyncd
        systemctl enable systemd-timesyncd
        systemctl start systemd-timesyncd
    fi

    #写入定时任务以确保时间同步
    (crontab -l 2>/dev/null; echo "*/20 * * * * chronyc burst 4/4 > /dev/null 2>&1 || systemctl restart systemd-timesyncd > /dev/null 2>&1") | crontab -

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

#安装vim
install_vim() {
	apt-get remove vim-common -y
	apt-get install vim -y
	sed -i 's/mouse=a/mouse-=a/g' /usr/share/vim/vim*/defaults.vim
}

# add_lias
add_alias() {
	cp ~/.bashrc ~/.bashrc.bak
	echo "alias ll='ls -l'" >> ~/.bashrc
	source ~/.bashrc
}

#调用函数执行
init_soft && init_timezone && set_swap && enable_bbr && change_ulimit && install_vim && add_alias
