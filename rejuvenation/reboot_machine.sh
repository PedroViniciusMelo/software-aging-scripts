#!/bin/bash

force=$1
soft=$2
ssh=$3
vm_name=$4

if [ "$soft" -eq 1 ]; then
  echo "Machine will reboot now | Graceful reboot"
  if vboxmanage controlvm "$vm_name" acpipowerbutton ; then
    until vboxmanage startvm "$vm_name" --type headless ; do
      sleep 1
      echo "Waiting for machine to shutdown"
    done

    exit 0
  fi
fi

if [ "$ssh" -eq 1 ]; then
  echo "Machine will reboot now | SSH reboot"
  ssh -p 2222 root@localhost "/sbin/shutdown -r now"
  exit 0
fi

if [ "$force" -eq 1 ]; then
  echo "Machine will reboot now | Forced reboot"
  vboxmanage controlvm "$vm_name" reset
  exit 0
fi
