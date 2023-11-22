#!/usr/bin/env bash

# CREATE_DISKS
# DESCRIPTION:
#   create a new disks on virtual machine
#
# LOCAL VARIABLES:
#   $counter
#
# PARAMETERS:
#   $1 = $disk_quantity
#   $2 = $disk_size
#
# VBOX COMMANDS:
#   VBoxManage createmedium disk
CREATE_DISKS() {
    local counter=1

    local disk_quantity=$1 # number of disks to be created
    local disk_size=$2      # disk size after created

    mkdir -p ../disks

    while [[ "$counter" -le "$disk_quantity" ]]; do
        VBoxManage createmedium disk --filename ../disks/disk$counter.vhd --size "$disk_size" --format VHD --variant Fixed
        ((counter++))
    done
}

# REMOVING_DISKS
# DESCRIPTION:
#   deletes virtual hard disks from the virtual machine except disks in use
#
# LOCAL VARIABLES:
#   $uuids_disks
#
# VBOX COMMANDS:
#   vboxmanage list hdds
#   vboxmanage closemedium disk
REMOVING_DISKS() {
    local uuids_disks
    uuids_disks=$(vboxmanage list hdds | awk '/UUID:/ && !/Parent UUID:/ {print $2}') # get 'UUID' with 'id' and remove 'Parent UUID'

    for uuid_disk in $uuids_disks; do
        echo -e "\n--->> Deleting disk with id: $uuid_disk \n"
        deleting_disk="$(vboxmanage closemedium disk "$uuid_disk" --delete 2>&1)"

        # Error Handling
        if [[ "$deleting_disk" == *"error:"* ]]; then
            echo -e "Error: Failed to delete medium with UUID: $uuid_disk \n"
            echo -e "***\nDetails: \n$deleting_disk \n***"
        else
            echo "Medium with UUID = $uuid_disk ( deleted successfully )"
        fi
    done
}
