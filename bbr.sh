#!/bin/bash
##########	CentOS 7安装BBR		###############

yum -y install wget
wget https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
rpm --import RPM-GPG-KEY-elrepo.org
rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm

#升级最新内核
yum --enablerepo=elrepo-kernel install kernel-ml -y
#设置最新内核
grub2-set-default 0

#写入配置文件
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf

#清理工作
rm -rf RPM-GPG-KEY-elrepo.org bbr.sh
#重启服务器
reboot
