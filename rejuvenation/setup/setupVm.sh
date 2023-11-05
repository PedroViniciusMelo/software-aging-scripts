#!/usr/bin/env bash
<<<<<<< HEAD

# GLOBAL VARIABLES
HOST_IP=$(hostname -I | awk '{print $1}')

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
  if ! vboxmanage controlvm vmDebian poweroff; then
    echo -e "ERROR: error when trying to shut down the vm\n"
  else
    echo -e "SUCCESS: the virtual machine was shutdown\n"
  fi

  if ! VBoxManage unregistervm vmDebian --delete; then
    echo -e "ERROR: error when trying to unregister the vm\n"
  else
    echo -e "WARNING: the vm was unregistered and its files were deleted\n"
  fi

  cd ../..

  if ! vboxmanage import vmDebian.ova; then
    echo -e "ERROR: error when trying to import vmDebian.ova\n"
  else
    echo -e "SUCCESS: The vm was imported successfully\n"
  fi

  if ! VBoxManage modifyvm vmDebian --natpf1 "porta 8080,tcp,$HOST_IP,8080,,80"; then
    echo -e "ERROR: error when trying to modify vmDebian\n"
  else
    echo -e "WARNING: network modifications were made to the virtual machine\n"
  fi

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
  local DISKS_QUANTITY=5
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
=======

############################################ START GLOBAL VARIABLES CONFIG
# HOST_IP=$(hostname -I | awk '{print $1}')
HOST_IP=$(hostname -I)
############################################ END GLOBAL VARIABLES CONFIG

############################################ START FUNCTIONS
CHECK_DEBIAN_IMAGE() {
  read -r -p "Have you copied the VM vmDebian.ova file? It should have been put one level before the rejuvenation folder (y/n): " copy

  if [ "$copy" != "y" ]; then
    echo -e "right, copy the debian system image to the location provided!\n"
    exit 1
  fi
}

CONTROL_VIRTUAL_MACHINE() {
  # virtual machina power off
  if ! vboxmanage controlvm vmDebian poweroff; then
    echo -e "\nerro ao tentar desligar a vm\n"
  else
    echo -e "\na vm foi desligada\n"
  fi

  # unregister the virtual machine and delete all files related to it
  if ! VBoxManage unregistervm vmDebian --delete; then
    echo -e "\nerro ao tentar desregistrar a vm\n"
  else
    echo -e "\na vm foi desregistrada e seus arquivos foram apagados\n"
  fi

  cd ../..

  if ! vboxmanage import vmDebian.ova; then
    echo -e "\nerro ao tentar importar a vmDebian.ova\n"
  else
    echo -e "\na vm foi importada com sucesso\n"
  fi

  if ! VBoxManage modifyvm vmDebian --natpf1 "porta 8080,tcp,$HOST_IP,8080,,80"; then
    echo -e "\nerro ao tentar modificar a vmDebian\n"
  else
    echo -e "\nmodificacoes de rede foram feitas na vm\n"
  fi

  cd rejuvenation/setup
}

DISKS_MANAGMENT() {
  local create_disks=$1
  local remove_disks=$2

  $remove_disks

  if ! $create_disks 5 10; then
    echo -e "\nerro ao criar o disco\n"
  else
    echo -e "\nsucesso ao criar discos\n"
  fi
}

START_VIRTUAL_MACHINE_IN_BACKGROUND() {
  read -r -p "\nDeseja ligar a vm? ( y | n ) - Default=n: \n" escolha

  if [[ "$escolha" == "y" ]]; then
    if ! vboxmanage startvm vmDebian --type headless; then
      echo -e "\nerro ao tentar iniciar a vmDebian em segundo plano / background\n"
    fi
  else
    echo -e "\na vm nao vai ser ligada\n"
  fi
}

COPY_SSH_ID_AND_TEST_VIRTUAL_MACHINE_SERVER() {
  if ! ssh-copy-id -i /root/.ssh/id_rsa.pub -p 2222 root@localhost; then
    echo -e "\nerro ao tentar se conectar a vmDebian via ssh\n"
  fi

  if ! curl http://localhost:8080; then
    echo -e "\nerro ao tentar iniciar o servidor nginx da vmDebian\n"
  fi
}
############################################ END FUNCTIONS
>>>>>>> d54b82f164400de4e96bc7a84b9549c8f1c4c627
