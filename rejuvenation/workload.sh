#!/bin/bash
source ./vbox_functions.sh

# PARAMETERS
# $1= disks path
# $2= quantity of disks
# USAGE
# ./workload.sh /disks/disk 50

readonly wait_time_after_attach=2
readonly wait_time_after_detach=2

WORKLOAD() {
  local count_disks=1
  local disk_path="disks/disk"

  while true; do
    for port in {1..3}; do
      ATTACH_DISK "${disk_path}$count_disks.vhd" "$port"
      sleep $wait_time_after_attach

      [[ "$count_disks" -lt 50 ]] && ((count_disks++))

    done

    if [[ "$count_disks" -eq 50 ]]; then
      for port in {1..3}; do
        DETACH_DISK "$port"
        sleep $wait_time_after_detach

      done
      count_disks=1
    fi

  done
}

WORKLOAD
