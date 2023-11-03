#!/usr/bin/env bash

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
