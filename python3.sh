#!/bin/bash

#####		CentOS 7一键安装Python 3		#####
#####		作者：xiaoz.me					#####
#####		更新时间：2018-07-20			#####

#导入环境变量
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin
export PATH

#安装依赖
function rely(){
	yum -y install wget gcc gcc-c++ libffi-devel zlib-devel
}

#安装Python 3.7函数
function install_py37(){
	#调用安装依赖函数
	rely
	#下载源码
	wget http://soft.xiaoz.org/python/Python-3.7.0.tar.xz
	#解压
	tar -xvJf Python-3.7.0.tar.xz
	cd Python-3.7.0
	#编译安装
	./configure --prefix=/usr/local/python3 --enable-optimizations
	make -j4 && make -j4 install
	#清理工作
	cd ..
	rm -rf Python-*
	#设置软连接
	ln -s /usr/local/python3/bin/python3.7 /usr/bin/python3
	ln -s /usr/local/python3/bin/pip3 /usr/bin/pip3
	echo "------------------------------------------------"
	echo '|	恭喜您，Python 3安装完成！  		 |'	
	echo "------------------------------------------------"
}

###卸载Python 3
function uninstall(){
	rm -rf /usr/local/python3
	rm -rf /usr/bin/python3
	rm -rf /usr/bin/pip3
	echo "------------------------------------------------"
	echo '|	Python 3已卸载！				 |'	
	echo "------------------------------------------------"
}

echo "------------------------------------------------------------"
echo 'CentOS 7一键安装Python 3脚本 ^_^ 请选择需要执行的操作：'
echo "1) 安装Python 3.7.0"
echo "2) 卸载Python 3"
echo "q) 退出！"
echo "------------------------------------------------------------"
read -p ":" istype

case $istype in
	1)
		install_py37
	;;
	2)
		uninstall
	;;
	'q')
		exit
	;;
	*)
		echo '参数错误！'
		exit
	;;
esac	