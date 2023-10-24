#!/bin/bash
cp -r /etc/apt/sources.list /etc/apt/sources.list.bak

echo "deb http://deb.debian.org/debian bullseye main contrib non-free" > /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian bullseye main contrib non-free" >> /etc/apt/sources.list
echo "" >> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian-security/ bullseye-security main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian-security/ bullseye-security main contrib non-free" >> /etc/apt/sources.list
echo "" >> /etc/apt/sources.list
echo "deb http://deb.debian.org/debian bullseye-updates main contrib non-free" >> /etc/apt/sources.list
echo "deb-src http://deb.debian.org/debian bullseye-updates main contrib non-free" >> /etc/apt/sources.list

apt update
apt upgrade -y

apt-get install systemtap linux-image-`uname -r`-dbg linux-headers-`uname -r` -y