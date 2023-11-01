#!/usr/bin/env bash

################################################################################
# Universidade Federal Rural de Pernambuco - Unidade Acadêmica de Garanhuns
# Uname Research Group
# Author - Thayson Guedes ( 31/10/2023 )
################################################################################

############################################################ START VARS CONFIG
COUNT=1                                                                                             # counter control
UUIDS_DISKS="$(vboxmanage list hdds | grep -w "UUID:" | grep -v "Parent UUID:" | awk '{print $2}')" # get 'UUID' with 'id' and remove 'Parent UUID'
############################################################ END VARS CONFIG

############################################################ START FUNCTIONS
# FUNCTION == CREATE_DISKS
# DESCRIPTION == create a new disks on virtual machine
#
# PARAMETERS:
#   $1 = $DISKS_QUANTITY
#   $2 = $DISK_SIZE
#
# GLOBAL VARIABLES:
#   $COUNT
CREATE_DISKS() {
    DISKS_QUANTITY=$1 # number of disks to be created
    DISK_SIZE=$2      # disk size after created

    while [[ "$COUNT" -le "$DISKS_QUANTITY" ]]; do
        VBoxManage createmedium disk --filename disk$COUNT.vhd --size "$DISK_SIZE" --format VHD --variant Fixed

        COUNT=$((COUNT + 1))
    done
}

CREATE_DISKS 5 10

# FUNCTION == REMOVING_DISKS
# DESCRIPTION == deletes virtual hard disks from the virtual machine except disks in use
#
# GLOBAL VARIABLES:
#   $UUIDS_DISKS
#
# virtualbox commands used:
#   vboxmanage closemedium disk
REMOVING_DISKS() {
    for uuid_disk in $UUIDS_DISKS; do
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
REMOVING_DISKS # using function
############################################################ END FUNCTIONS