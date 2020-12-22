#!/bin/bash
#####	设置虚拟内存				#####
#####	update：2020/12/22			#####
#####	author:xiaoz<xiaoz93@outlook.com>

#获取物理内存
p_mem=`free -m|grep Mem|awk '{print $2}'`
#获取最佳虚拟内存大小

#内存如果小于2g，则设置2倍
if [ $p_mem -lt 2000 ]
	then
	swap_value=$p_mem*2
elif [ $p_mem -gt 2000 ] && [ $p_mem -lt 8000 ]
	#内存大于2G，小于8G，则设置和物理内存大小一致
	then
	swap_value=$p_mem
else
	#其他情况，比如大于8G，则设置8G内存
	swap_value=8000
fi


#设置swap函数
function set_swap(){
	#创建swap
	dd if=/dev/zero of=/dev/swap bs=1M count=${swap_value}
	mkswap /dev/swap
	swapon /dev/swap
	#写入分区表
	echo '/dev/swap swap                    swap    defaults        0 0' >> /etc/fstab
}

#判断当前是否开启了虚拟内存
if swapon -s
then
	echo '---------------------------------'
	echo 'You have already set up swap, there is no need to repeat the settings.'
	exit
else
	#设置虚拟内存
	set_swap
	echo '---------------------------------'
	echo 'Swap setup complete.'
	echo '---------------------------------'
	swapon -s
	echo '---------------------------------'
	free -mt
	echo '---------------------------------'
fi

exit