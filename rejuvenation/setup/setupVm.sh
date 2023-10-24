#!/bin/bash
echo "Have you copied the VM vmDebian.ova file? It should have been put one level before the rejuvenation folder(y/n)"
read -r copy

if [ "$copy" != "y" ]; then
  exit 1
fi

vboxmanage controlvm vmDebian poweroff
VBoxManage unregistervm vmDebian --delete
./remove-disks.sh

mkdir ../disks
cp create-disks.sh ../disks
cd ../disks || exit

./create-disks.sh 51 1024

cd ..
cd ..

vboxmanage import vmDebian.ova

HOST_IP=$(hostname -I | awk '{print $1}')
VBoxManage modifyvm vmDebian --natpf1 "porta 8080,tcp,$HOST_IP,8080,,80"

vboxmanage startvm vmDebian --type headless

sleep 30

ssh-copy-id -i /root/.ssh/id_rsa.pub -p 2222 root@localhost

curl http://localhost:8080
