#!/bin/bash
#####		一键安装Rsync		#####
#####		Update:2018-03-25			#####
#####		Author:xiaoz.me				#####

yum -y install wget
#卸载原有rsync
yum -y remove rsync

wget http://soft.xiaoz.org/linux/rsync-3.1.3.tar.gz
tar -zxvf rsync-3.1.3.tar.gz
cd rsync-*

#安装
./configure && make install

echo '安装完成，信息如下：'

rsync -v