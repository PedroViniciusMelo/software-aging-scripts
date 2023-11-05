#!/usr/bin/env bash

<<<<<<< HEAD
# Universidade Federal Rural de Pernambuco - Unidade Acadêmica de Garanhuns
# Uname Research Group
# Author - Thayson Guedes ( 31/10/2023 )

# GLOBAL VARIABLES
COUNT=1                                                                           # counter control
UUIDS_DISKS=$(vboxmanage list hdds | awk '/UUID:/ && !/Parent UUID:/ {print $2}') # get 'UUID' with 'id' and remove 'Parent UUID'

# CREATE_DISKS
# DESCRIPTION:
#   create a new disks on virtual machine
=======
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
>>>>>>> d54b82f164400de4e96bc7a84b9549c8f1c4c627
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

    mkdir -p ../disks

    while [[ "$COUNT" -le "$DISKS_QUANTITY" ]]; do
        VBoxManage createmedium disk --filename ../disks/disk$COUNT.vhd --size "$DISK_SIZE" --format VHD --variant Fixed

<<<<<<< HEAD
        ((COUNT++))
    done
}

# REMOVING_DISKS
# DESCRIPTION:
#   deletes virtual hard disks from the virtual machine except disks in use
=======
        COUNT=$((COUNT + 1))
    done
}

# FUNCTION == REMOVING_DISKS
# DESCRIPTION == deletes virtual hard disks from the virtual machine except disks in use
>>>>>>> d54b82f164400de4e96bc7a84b9549c8f1c4c627
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
<<<<<<< HEAD
=======
############################################################ END FUNCTIONS
>>>>>>> d54b82f164400de4e96bc7a84b9549c8f1c4c627
