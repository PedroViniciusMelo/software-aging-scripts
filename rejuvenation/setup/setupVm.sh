#!/usr/bin/env bash

# GLOBAL VARIABLES
HOST_IP=$( hostname -I )

# UTILS
#   ERROR HANDLE
ERROR_HANDLING() {
    local error=$1
    local status=$2
    [[ $status -eq 0 ]] || {
        echo -e "\nERROR: $error\n"
        exit 1
    }

}

# ERRORS MESSAGES
readonly poweroff="error when turning off the virtual machine, it may already be turned off!"
readonly unregister="unregistering and deleting files from vmDebian"
readonly import="Importing vmDebian.ova"
readonly modify="modifying vmDebian ports and network"

# CHECK_DEBIAN_IMAGE
# DESCRIPTION:
#   checks if the virtual machine file vmDebian.ova is in a folder before the rejuvenation folder
CHECK_DEBIAN_IMAGE() {
  read -r -p "Have you copied the VM vmDebian.ova file? It should have been put one level before the rejuvenation folder (y/n): " copy

  if [ "$copy" != "y" ]; then
    echo -e "right, copy the debian system image to the location provided!\n"
    exit 1
  fi
}

# CONTROL_VIRTUAL_MACHINE
# DESCRIPTION:
#   vboxmanage controlvm vmDebian poweroff:
#       try to turn off the virtual machine
# 
#   VBoxManage unregistervm vmDebian --delete:
#       Attempts to unregister the virtual machine and delete all files associated with it
# 
#   vboxmanage import vmDebian.ova
#       import the virtual machine vmDebian.ova
# 
#   VBoxManage modifyvm vmDebian --natpf1 "porta 8080,tcp,$HOST_IP,8080,,80"
#       Attempts to modify the virtual machine to forward traffic from host port 8080 to virtual machine port 80
CONTROL_VIRTUAL_MACHINE() {
  vboxmanage controlvm vmDebian poweroff
  ERROR_HANDLING "$poweroff" 0

  VBoxManage unregistervm vmDebian --delete
  ERROR_HANDLING "$unregister" $?

  cd ../..

  vboxmanage import vmDebian.ova
  ERROR_HANDLING "$import" $?

  VBoxManage modifyvm vmDebian --natpf1 "porta 8080,tcp,$HOST_IP,8080,,80"
  ERROR_HANDLING "$modify" $?

  cd rejuvenation/setup
}

# DISKS_MANAGMENT
# DESCRIPTION:
#     removes all disks from the virtual machine
#     creates disks in the virtual machine from the given quantity and size
# 
# PARAMETERS:
#   $1 == create disks
#   $2 == remove disks
DISKS_MANAGMENT() {
  local create_disks=$1
  local remove_disks=$2

  $remove_disks

  # define a desired quantity and size of disks to perform the tests
  local DISKS_QUANTITY=50
  local DISKS_SIZE=10

  if ! $create_disks $DISKS_QUANTITY $DISKS_SIZE; then
    echo -e "ERROR: error creating disk\n"
  else
    echo -e "SUCCESS: success in creating disks of quantity $DISKS_QUANTITY and size $DISKS_SIZE\n"
  fi
}

# START_VIRTUAL_MACHINE_IN_BACKGROUND
# DESCRIPTION:
#   
START_VIRTUAL_MACHINE_IN_BACKGROUND() {
  read -r -p "Do you want to connect the vm? ( y | n ) - Default=n: \n" choice

  if [[ "$choice" == "y" ]]; then
    if ! vboxmanage startvm vmDebian --type headless; then
      echo -e "ERROR: error when trying to start vmDebian in the background\n"
    fi
  else
    echo -e "WARNING: the vm will not be turned on\n"
  fi
}

# COPY_SSH_ID_AND_TEST_VIRTUAL_MACHINE_SERVER
# DESCRIPTION:
#   ALALAL
COPY_SSH_ID_AND_TEST_VIRTUAL_MACHINE_SERVER() {
  if ! ssh-copy-id -i /root/.ssh/id_rsa.pub -p 2222 root@localhost; then
    echo -e "ERROR: error when trying to connect to vmDebian via ssh\n"
  fi

  if ! curl http://localhost:8080; then
    echo -e "ERROR: error when trying to start vmDebian's nginx server\n"
  fi
}
