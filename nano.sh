#!/bin/bash
#####	Nano管理脚本						#####
#####	Author:xiaoz<xiaoz93@outlook.com	#####
#####	Update:2020/05/10					#####

#nano的文件路径
core='/opt/nano/core/core'
cell='/opt/nano/cell/cell'
frontend='/opt/nano/frontend/frontend'

#如果参数不存在,则默认启动nano相关服务
if [ ! $1 ]
	then
		$core start
		$cell start
		$frontend start
		exit
fi

#根据不同的选项执行不同的操作
case $1 in
	'start')
		$core start
		$cell start
		$frontend start
		;;
	'status')
		$core status
		$cell status
		$frontend status
		;;
	'stop')
		$core stop
		$cell stop
		$frontend stop
		;;
	'restart')
		$core stop
		$cell stop
		$frontend stop
		sleep 5s
		$core start
		$cell start
		$frontend start
		;;
	*)
		echo 'Parameter error!'
		exit
		;;
esac