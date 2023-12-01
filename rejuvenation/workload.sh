#!/bin/bash
#!/bin/bash
# UFAPE
# Uname Research Group
# Felipe Oliveira 25/10/2018
# Pedro Vinícius 11/03/2022

# PARAMETERS
# $1= virtual machine name
# $2= path of the disks
# $3= quantidade de discos
#usage ./workload.sh vmDebian disks/ 50

wait_time_after_attach=10
wait_time_after_detach=10
count_disks=1

while true; do
  vboxmanage storageattach "$1" --storagectl "SATA" --device 0 --port 1 --type hdd --medium "$2$count_disks.vhd"
  sleep $wait_time_after_attach

  vboxmanage storageattach "$1" --storagectl "SATA" --device 0 --port 1 --type hdd --medium none
  sleep $wait_time_after_detach


  if [ "$count_disks" -lt "$3" ]; then
    ((count_disks++))
  else
    count_disks=1
  fi
done
