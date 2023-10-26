#!/usr/bin/env bash

################################################################################
# Universidade Federal Rural de Pernambuco - Unidade Acadêmica de Garanhuns
# Uname Research Group
# Felipe Oliveira 09/11/2018
# refactor - Thayson Guedes ( 25/10/2023 )
################################################################################

################################### CONFIG VARS
COUNT=1 # counter control

################################### START FUNCTIONS
# create a new disks on virtual machine
# parameters:
#   $1 = $DISKS_QUANTITY
#   $2 = $DISK_SIZE
#
# global variables:
#   count
CREATE_DISKS() {
    DISKS_QUANTITY=$1 # number of disks to be created
    DISK_SIZE=$2      # disk size after created
    
    while [[ "$COUNT" -le "$DISKS_QUANTITY" ]]; do
        VBoxManage createmedium disk --filename disk$COUNT.vhd --size "$DISK_SIZE" --format VHD --variant Fixed

        COUNT=$((COUNT + 1))
    done
}
################################### END FUNCTIONS

CREATE_DISKS 5 10
