#!/usr/bin/env bash

<<<<<<< HEAD
=======
# main script to call all others from the setup folder and
# define initial and dependency settings

>>>>>>> d54b82f164400de4e96bc7a84b9549c8f1c4c627
################################################# START IMPORTS
source ./dependencies.sh
source ./setupVm.sh
source ./disk_management.sh
<<<<<<< HEAD

# CHECK_ROOT
# DESCRIPTION:
#   check if script is running as root
CHECK_ROOT() {
    if [[ "$EUID" -ne 0 ]]; then
        echo "Run Script as Super Administrator ( need root )"
        exit 1
    fi
}

# MAIN_SETUP
# DESCRIPTION:
#   start
MAIN_SETUP() {
    CHECK_ROOT

    read -r -p "Do you want to check dependencies? ( y | n ) - Default=n: " choise

    if [[ "$choise" == "y" ]]; then
        echo "checking dependencies"

        START_DEPENDENCIES && wait # ./dependencies.sh
    else
        echo "will not check dependencies"
=======
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
>>>>>>> d54b82f164400de4e96bc7a84b9549c8f1c4c627

        ################################## START ./setupVm.sh
        CHECK_DEBIAN_IMAGE && wait
        CONTROL_VIRTUAL_MACHINE && wait

        DISKS_MANAGMENT CREATE_DISKS REMOVING_DISKS && wait

        START_VIRTUAL_MACHINE_IN_BACKGROUND && wait
        COPY_SSH_ID_AND_TEST_VIRTUAL_MACHINE_SERVER
        ################################## END ./setupVm.sh
    fi
}
<<<<<<< HEAD
MAIN_SETUP
=======
MAIN_SETUP
################################################# END MAIN_SETUP
>>>>>>> d54b82f164400de4e96bc7a84b9549c8f1c4c627
