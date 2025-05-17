#!/bin/bash

apt-get update && apt-get clean && rm -rf /var/lib/apt/lists/*

passwd -d ubuntu

sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen 
sed -i '/ja_JP.UTF-8/s/^# //g' /etc/locale.gen
locale-gen ja_JP.UTF-8
update-locale LANG=ja_JP.UTF-8
echo $TZ > /etc/timezone 
ln -fs /usr/share/zoneinfo/$TZ /etc/localtime 
dpkg-reconfigure -f noninteractive tzdata 