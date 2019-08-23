#!/bin/bash
##########	name:图片压缩脚本					##########
##########	author:xiaoz<xiaoz93@outlook.com>	##########
##########	Blog:https://www.xiaoz.me/			##########
##########	update:2019-08-23					##########

#导入环境变量
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/bin:/sbin
export PATH

#设置图片绝对路径
imgpath=''
#最低图片大小，高于此大小的图片才会进行压缩
min_size='100k'

#判断图片路径是否为空
if [ -z $imgpath ]
then
	imgpath=$1
fi

if [ -z $imgpath ]
then
	echo 'The image path cannot be empty!'
	exit
fi

#压缩png/jpg/bmp图像
function com_img(){
	#使用optipng压缩.png和.bmp
	find $1 -mmin -60 -size +$2 -name '*.png' -exec optipng -o3 {} \;
	find $1 -mmin -60 -size +$2 -name '*.bmp' -exec optipng -o3 {} \;

	#使用jpegoptim压缩.jpg
	find $1 -mmin -60 -size +$2 -name '*.jpg' -exec jpegoptim -m 80 {} \;
	find $1 -mmin -60 -size +$2 -name '*.jpeg' -exec jpegoptim -m 80 {} \;
}

#调用压缩函数
com_img $imgpath $min_size
