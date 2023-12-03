#!/bin/bash
source ./vbox_functions.sh

# PARAMETERS
# $1= disks path
# $2= quantity of disks
# USAGE
# ./workload.sh /disks/disk 50

readonly wait_time_after_attach=10
readonly wait_time_after_detach=10
count_disks=1

while true; do
  disk_path="$1$count_disks.vhd"

  for port in {1..3}; do
    for _ in {1..3}; do
      #Fazer um while para anexar múltiplos discos, mesma coisa para desanexar em sequência
      ATTACH_DISK "$disk_path" "$port"
      sleep $wait_time_after_attach

      if [ "$count_disks" -lt "$3" ]; then
        ((count_disks++))
      else
        count_disks=1
      fi
    done
  done

  if "$count_disks" -eq 50; then
    while i -ne 50; do
      for port in {1..3}; do
        for _ in {1..3}; do
          DETACH_DISK "$port"
          sleep $wait_time_after_detach

          ((i++))
        done
      done
    done
    count_disks=1
  fi

done
