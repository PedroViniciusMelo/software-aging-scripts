#!/bin/bash
# Universidade Federal Rural de Pernambuco - Unidade Acadêmica de Garanhuns 
# Uname Research Group
# Felipe Oliveira 09/11/2018

# Parameters 
# $1 = number of disks

count=1

while [ $count -lt $1 ]
do
    VBoxManage createmedium disk --filename disk$count.vhd --size 1024 --format VHD --variant Fixed
    count=`expr $count + 1`
done
