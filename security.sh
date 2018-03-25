#!/bin/bash
##########	安全设置脚本	##########

read -p "修改主机名（留空则不修改，请直接回车）：" myhostname
read -p "修改SSH端口：" sshport

if [ "$myhostname" != '' ]
then
	sudo hostnamectl set-hostname ${myhostname}
elif [ "$sshport" != '' && "$myhostname" != '' ]
	then
	#删除SSH端口
	sed -i '/^#Port/'d /etc/ssh/sshd_config
	sed -i '/^Port/'d /etc/ssh/sshd_config
	#添加端口
	sed -i "/^#AddressFamily/i\Port ${sshport}" /etc/ssh/sshd_config
	#重载服务
	service sshd restart
	echo "修改完成."
else
	exit
fi