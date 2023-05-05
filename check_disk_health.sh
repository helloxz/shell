#!/bin/bash

# 检查 smartmontools 是否已安装
if [ -x "$(command -v smartctl)" ]; then
  echo "smartmontools 已安装"
else
  echo "正在安装 smartmontools..."
  if [ -x "$(command -v apt-get)" ]; then
    sudo apt-get update && sudo apt-get install -y smartmontools
  elif [ -x "$(command -v yum)" ]; then
    sudo yum install -y smartmontools
  else
    echo "无法确定包管理器，请手动安装 smartmontools"
    exit 1
  fi
fi

# 获取磁盘设备列表
disks=$(lsblk -dpno NAME,TYPE | awk '$2=="disk" {print $1}')

# 检查磁盘健康状况
for disk in $disks; do
  echo "正在检查磁盘 $disk 的健康状况..."
  health_status=$(sudo smartctl -H $disk | grep "SMART overall-health")
  echo "磁盘 $disk 的健康状况：$health_status"
  echo "----------------------------------------"
done
