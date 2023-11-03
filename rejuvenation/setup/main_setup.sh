#!/usr/bin/env bash

# main script to call all others from the setup folder and
# define initial and dependency settings

################################################# START IMPORTS
source ./dependencies.sh
source ./setupVm.sh
source ./disk_management.sh
################################################# END IMPORTS

[[ "$EUID" -ne 0 ]] && echo "Run Script as Super Administrator ( need root )" && exit 1

################################################# START MAIN_SETUP
MAIN_SETUP() {
    read -r -p "Deseja verificar dependencias? ( y | n ) - Default=n: " escolha

    if [[ "$escolha" == "y" ]]; then
        echo "verificando dependencias"

        START_DEPENDENCIES && wait # ./dependencies.sh
    else
        echo "nao ira verificar dependencias"

        ################################## START ./setupVm.sh
        CHECK_DEBIAN_IMAGE && wait
        CONTROL_VIRTUAL_MACHINE && wait

        DISKS_MANAGMENT CREATE_DISKS REMOVING_DISKS && wait

        START_VIRTUAL_MACHINE_IN_BACKGROUND && wait
        COPY_SSH_ID_AND_TEST_VIRTUAL_MACHINE_SERVER
        ################################## END ./setupVm.sh
    fi
}
MAIN_SETUP
################################################# END MAIN_SETUP
