#!/bin/bash

################################################################################
# Universidade Federal Rural de Pernambuco - Unidade Acadêmica de Garanhuns
# Uname Research Group
# Felipe Oliveira 09/11/2018
# refactor - Thayson Guedes ( 25/10/2023 )
################################################################################

################################### CONFIG VARS
count=1           # counter control
DISKS_QUANTITY=$1 # number of disks to be created
DISK_SIZE=$2      # disk size after created

################################### START FUNCTIONS
# create a new disks on virtual machine
# parameters:
#   $1 = $DISKS_QUANTITY
#   $2 = $DISK_SIZE
#
# global variables:
#   count
CREATE_DISKS() {
    while [ "$count" -lt "$DISKS_QUANTITY" ]; do
        VBoxManage createmedium disk --filename disk$count.vhd --size "$DISK_SIZE" --format VHD --variant Fixed

        count=$(("$count" + 1))
    done
}
################################### END FUNCTIONS
