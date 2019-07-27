#!/bin/bash
##########		Shell多合一工具箱						##########
##########		Author:xiaoz<xiaoz93@outlook.com>		##########
##########		Update:2019-07-27						##########

echo ''
echo	'-------------------------------------------------'
echo	"";
echo	'		多合一Shell工具箱					'
echo ""
echo	'-------------------------------------------------'

echo '1) 安装BBR'
echo '2) 安装Zabbix Agent'
echo '3) 安装Python3'
echo '4) 设置时区(Shanghai)并自动同步'
echo '5) Bench.sh测试'
echo '6) 安装XCDN'
echo '7) Mping测试'
echo	'-------------------------------------------------'

read -p "请输入要执行的脚本：" num

case $num in
	'1')
		bash ./bbr.sh
		;;
	'2')
		bash ./zabbix_agent.sh
		;;
	'3')
		bash ./python3.sh
		;;
	'4')
		bash ./synctime.sh
		;;
	'5')
		yum -y install wget curl
		wget -qO- bench.sh | bash
		;;
	'6')
		yum -y install wget curl
		wget https://raw.githubusercontent.com/helloxz/nginx-cdn/master/nginx.sh && bash nginx.sh
		;;
	'7')
		yum -y install wget
		wget https://raw.githubusercontent.com/helloxz/mping/master/mping.sh && bash mping.sh
		;;
	*)
		echo '参数错误！'
		exit;
		;;
esac