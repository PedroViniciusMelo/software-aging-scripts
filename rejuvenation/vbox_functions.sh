#!/usr/bin/env bash

# Universidade Federal do Agreste de Pernambuco
# Uname Research Group

# GLOBAL VARIABLES:
VM_NAME="vmDebian"

# TURN VM OFF FUNCTION
# DESCRIPTION:
#   VBoxManage controlvm vmDebian poweroff:
#     Tries to turn off the virtual machine
TURN_VM_OFF() {
  vboxmanage controlvm "$VM_NAME" poweroff
}

# DELETE VM FUNCTION
# DESCRIPTION:
#   VBoxManage unregistervm vmDebian --delete:
#     Unregisters the virtual machine and delete all files associated with it
DELETE_VM() {
  vboxmanage unregistervm "$VM_NAME" --delete
}

# GRACEFUL REBOOT FUNCTION
# DESCRIPTION:
#   Initiates a graceful reboot using ACPI power button. It has the same effect of pressing the power button on a physical pc.
# VIRTUAL BOX COMMANDS:
#   VBoxManage controlvm "$VM_NAME" acpipowerbutton
GRACEFUL_REBOOT() {
  vboxmanage controlvm "$VM_NAME" acpipowerbutton
}

# FORCED REBOOT FUNCTION
# DESCRIPTION:
#   Initiates a forced reboot.
# VIRTUAL BOX COMMANDS:
#   VBoxManage controlvm "$VM_NAME" reset
FORCED_REBOOT() {
  vboxmanage controlvm "$VM_NAME" reset
}  

# CREATE VM FUNCTION
# DESCRIPTION:
#   VBoxManage import vmDebian.ova
#      Imports the virtual machine vmDebian.ova
#   VBoxManage modifyvm vmDebian --natpf1 "porta 8080,tcp,$host_ip,8080,,80"
#      Attempts to modify the virtual machine to forward traffic from host port 8080 to virtual machine port 80
CREATE_VM() {
  local host_ip
  host_ip=$(hostname -I | awk '{print $1}') 
  cd .. #(adjust as needed based on the final file organization)
  vboxmanage import vmDebian.ova
  vboxmanage modifyvm vmDebian --natpf1 "porta 8080,tcp,$host_ip,8080,,80"
}

# REMOVE DISKS FUNCTION
# DESCRIPTION:
#   Attempts to remove all disks from virtual machine
# PARAMETERS:
#   $UUIDS_DISKS 
# VIRTUAL BOX COMMANDS:
#   VBoxManage closemedium disk
REMOVE_DISKS() {
    uuids_disks=$(VBoxManage list hdds | awk '/UUID:/ && !/Parent UUID:/ {print $2}') # get 'UUID' with 'id' and remove 'Parent UUID'

    for uuid_disk in $uuids_disks; do
        echo -e "\n--->> Deleting disk with id: $uuid_disk \n"
        deleting_disk="$(VBoxManage closemedium disk "$uuid_disk" --delete 2>&1)"

        if [[ "$deleting_disk" == *"error:"* ]]; then
            echo -e "Error: Failed to delete medium with UUID: $uuid_disk \n"
            echo -e "***\nDetails: \n$deleting_disk \n***"
        else
            echo "Medium with UUID = $uuid_disk (deleted successfully)"
        fi
    done
}

# CREATE DISKS FUNCTION
# DESCRIPTION:
#   Creates disks in the virtual machine from the given quantity and size
# VIRTUAL BOX COMMAND:
#   VBoxManage createmedium disk 
# PARAMETERS:
# $1 = amount of disks to be created
# $2 = size in MB for each disk
# USAGE:
#  In the main script (run.sh):
#  source ./vbox_functions.sh
#  CREATE_DISKS 50 10
CREATE_DISKS() {
    count=1   
    disks_quantity=$1 
    disk_size=$2      

    mkdir -p ../disks

    while [[ "$COUNT" -le "$disks_quantity" ]]; do
        VBoxManage createmedium disk --filename ../disks/disk$COUNT.vhd --size "$disk_size" --format VHD --variant Fixed

        ((COUNT++))
    done
}

# START VIRTUAL MACHINE FUNCTION
# DESCRIPTION:
#   Attempts to start the vm in the background
# PARAMETERS:
#   Global variable used: VM_NAME - virtual machine name
#  VIRTUAL BOX COMMANDS:
#   VBoxManage startvm "$VM_NAME" --type headless
START_VM() {
  if VBoxManage list runningvms | grep -q "vmDebian"; then
    echo -e "WARNING: the vm is already running.\n"
  else
    VBoxManage startvm "$VM_NAME" --type headless
  fi
}
  
# ATTACH DISK FUNCTION
# DESCRIPTION:
#   Attaches disks to virtual machine
# PARAMETERS:
#   Global variable used: VM_NAME - virtual machine name
#   $1 = disk path
# VIRTUAL BOX COMMANDS:
#  VBoxManage storageattach ... --medium "$disk_path"
# USAGE:
#  In the main script (run.sh):
#  source ./vbox_functions.sh
#  ATTACH_DISK software-aging/disks/disk1.vhd
ATTACH_DISK() {
  local disk_path="$1"
  VBoxManage storageattach "$VM_NAME" --storagectl "SATA" --device 0 --port 1 --type hdd --medium "$disk_path"
}

# DEATACH DISK FUNCTION
# DESCRIPTION:
#   Dettaches disks to virtual machine
# PARAMETERS:
#   Global variable: virtual machine name
# VIRTUAL BOX COMMANDS:
#  VBoxManage storageattach ... --medium none
DETACH_DISK() {
  VBoxManage storageattach "$VM_NAME" --storagectl "SATA" --device 0 --port 1 --type hdd --medium none
}