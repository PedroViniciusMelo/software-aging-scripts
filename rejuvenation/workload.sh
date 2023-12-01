#!/bin/bash
source ./vbox_functions.sh

# PARAMETERS
# $1= disks path
# $2= quantity of disks
# USAGE 
# ./workload.sh /disks/disk 50

wait_time_after_attach=10
wait_time_after_detach=10
count_disks=1

while true; do
  disk_path="$1$count_disks.vhd"

  #Fazer um while para anexar múltiplos discos, mesma coisa para desanexar em sequência
  ATTACH_DISK "$disk_path"
  sleep $wait_time_after_attach

  DETACH_DISK
  sleep $wait_time_after_detach

  if [ "$count_disks" -lt "$3" ]; then
    ((count_disks++))
  else
    count_disks=1
  fi
done
