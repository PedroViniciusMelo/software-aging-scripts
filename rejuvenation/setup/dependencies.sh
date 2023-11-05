#!/usr/bin/env bash

<<<<<<< HEAD
# GLOBAL_VARIABLES
# DESCRIPTION:
#   start globall tools
GLOBAL_VARIABLES() {
    KERNEL_VERSION=$(uname -r)
}

# CHECK_ROOT
# DESCRIPTION:
#   check if script is running as root
CHECK_ROOT() {
    if [[ "$EUID" -ne 0 ]]; then
        echo "Run Script as Super Administrator ( need root )"
        exit 1
    fi
}

# GET_DISTRIBUTION
# DESCRIPTION:
#   verify linux distribution and get id of distribution
#
# GLOBAL_VARS_CONFIG:
#   $DISTR_ID
#   $DISTR_CODENAME
GET_DISTRIBUTION() {
    if [[ -f "/etc/os-release" ]]; then
        source /etc/os-release
        DISTR_ID="$ID"
        DISTR_CODENAME="$VERSION_CODENAME"
=======
######################################## START GLOBAL VARS CONFIG
GLOBAL_VARIABLES() {
    [[ "$EUID" -ne 0 ]] && echo "Run Script as Super Administrator ( need root )" && exit 1
    OS_RELEASE=/etc/os-release
    KERNEL_VERSION=$(uname -r)
    DISTR_CODENAME=$(cat < "$OS_RELEASE" | grep -w "VERSION_CODENAME" | awk -F= '{print $2}')
    DISTR_ID=$(cat < "$OS_RELEASE" | grep -w "ID" | awk -F= '{print $2}')
}
######################################## END GLOBAL VARS CONFIG

######################################## START FUNCTIONS

# FUNCTION == VERIFY_DISTRIBUTION
# DESCRIPTION == verify linux distribution and get id of distribution
#
# GLOBAL_VARS_CONFIG:
#   $DISTR_ID
VERIFY_DISTRIBUTION() {
    if [[ -f "$OS_RELEASE" ]]; then
        DISTRIBUTION_ID=$DISTR_ID
>>>>>>> d54b82f164400de4e96bc7a84b9549c8f1c4c627
        return 0
    else
        echo -e "\nERROR: error when obtaining the machine's distro id\n" && exit 1
    fi
}

<<<<<<< HEAD
# INSTALLING_PACKAGES
# DESCRIPTION:
#   install linux-headers, linux-image, gnupg, wget, curl, sysstat, openssh-server and systemtap
INSTALLING_PACKAGES() {
    # if ! apt install linux-headers-"$KERNEL_VERSION" linux-image-"$KERNEL_VERSION"-dbg -y; then
    #     echo -e "\nERROR: Error installing Linux packages\n" >&2
    #     exit 1
    # else
    #     echo -e "\nInstalled linux packages\n"
    # fi

    # if ! apt install gnupg wget curl sysstat systemtap openssh-server -y; then
    #     echo -e "\nERROR: Error installing general packages\n" >&2
    #     exit 1
    # else
    #     echo -e "\nInstalled general packages\n"
    # fi

    apt update

    apt install linux-headers-"$KERNEL_VERSION" linux-image-"$KERNEL_VERSION"-dbg gnupg wget curl sysstat systemtap openssh-server -y || {
        echo -e "\nERROR: Error installing Linux packages and Error installing general packages\n"
        exit 1
    }
}

# CHECKING_STAP_AVAILABLE
# DESCRIPTION:
#   checking stap command availability
=======
# FUNCTION == INSTALLING_PACKAGES
# DESCRIPTION == install linux-headers, linux-image, gnupg, wget, curl, sysstat, openssh-server and systemtap
INSTALLING_PACKAGES() {
    if ! apt install linux-headers-"$KERNEL_VERSION" linux-image-"$KERNEL_VERSION"-dbg -y; then
        echo -e "\nERROR: Error installing Linux packages\n" >&2
        exit 1
    else
        echo -e "\nInstalled linux packages\n"
    fi

    if ! apt install gnupg wget curl sysstat systemtap openssh-server -y; then
        echo -e "\nERROR: Error installing general packages\n" >&2
        exit 1
    else
        echo -e "\nInstalled general packages\n"
    fi
}

# FUNCTION == CHECKING_STAP_AVAILABLE
# DESCRIPTION == checking stap command availability
>>>>>>> d54b82f164400de4e96bc7a84b9549c8f1c4c627
CHECKING_STAP_AVAILABLE() {
    if command -v stap &>/dev/null; then
        echo -e "\nsystemtap is already installed\n"
        echo -e "\nEXECUTING THE STAP COMMAND:"

        stap -v -e 'probe oneshot { println("hello world") }'

        return 0
    else
        echo -e "\nsystemtap is not installed\n" >&2
        exit 1
    fi
}

<<<<<<< HEAD
# CONFIGURE_SYSTEMTAP_BINARIES
# DESCRIPTION:
#   Systemtap may need a linux-build style System.map file to find kernel function/data addresses.
=======
# FUNCTION == CONFIGURE_SYSTEMTAP_BINARIES
# DESCRIPTION == Systemtap may need a linux-build style System.map file to find kernel function/data addresses.
>>>>>>> d54b82f164400de4e96bc7a84b9549c8f1c4c627
#   It may be possible to create it manually
#
# REFERENCES:
#   https://man7.org/linux/man-pages/man7/warning::symbols.7stap.html
CONFIGURE_SYSTEMTAP_BINARIES() {
    echo -e "\nconfiguring debug binaries for systemtap...\n"

<<<<<<< HEAD
    cp /proc/kallsyms /boot/System.map-"$KERNEL_VERSION"
=======
    cp /proc/kallsyms /boot/System.map-"$(uname -r)" && sleep 2
>>>>>>> d54b82f164400de4e96bc7a84b9549c8f1c4c627

    if [[ $? -eq 0 ]]; then
        echo -e "\nSUCCESS: successfully configured!\n"
        return 0
    else
        echo -e "\nERROR: configuration of systemtap debug binaries failed\n" && exit 1
    fi
}

<<<<<<< HEAD
# DOWNLOADING_VIRTUALBOX
# DESCRIPTION:
#   backup of sourcers.list, configure and add repository, assiganture keys and download of virtualbox-7.0
=======
# FUNCTION == DOWNLOADING_VIRTUALBOX
# DESCRIPTION == backup of sourcers.list, configure and add repository, assiganture keys and download of virtualbox-7.0
>>>>>>> d54b82f164400de4e96bc7a84b9549c8f1c4c627
DOWNLOADING_VIRTUALBOX() {
    mkdir -p /etc/apt/backup
    cp /etc/apt/sources.list /etc/apt/backup/

<<<<<<< HEAD
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian $DISTR_CODENAME contrib" >>/etc/apt/sources.list
=======
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian $DISTR_CODENAME contrib" >> /etc/apt/sources.list
>>>>>>> d54b82f164400de4e96bc7a84b9549c8f1c4c627

    wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg

    apt update
<<<<<<< HEAD
    if ! apt install virtualbox-7.0 -y; then
=======
    if ! apt install virtualbox-7.0 -y ; then
>>>>>>> d54b82f164400de4e96bc7a84b9549c8f1c4c627
        echo -e "\nVirtualBox installed successfully\n"
    else
        echo -e "\nERROR: Error when trying to install virtualbox\n" >&2
        exit 1
    fi
}
<<<<<<< HEAD

# START_DEPENDENCIES
# DESCRIPTION:
#   starts dependency checking
START_DEPENDENCIES() {
    CHECK_ROOT

    GLOBAL_VARIABLES # get global variables
    GET_DISTRIBUTION # get id and version codename of machine dist
=======
######################################## END FUNCTIONS

######################################## START PRINCIPAL PROGRAM
START_DEPENDENCIES() {
    
    GLOBAL_VARIABLES    # get global variables
    VERIFY_DISTRIBUTION # get id of machine dist
>>>>>>> d54b82f164400de4e96bc7a84b9549c8f1c4c627

    case $DISTRIBUTION_ID in
        "debian")
            clear

<<<<<<< HEAD
            INSTALLING_PACKAGES && wait          # installing util packages and linux packages
            CHECKING_STAP_AVAILABLE && wait      # checking if stap available
            CONFIGURE_SYSTEMTAP_BINARIES && wait # config depuration of systemtap
            DOWNLOADING_VIRTUALBOX               # download virtualbox

            apt update

            echo -e "\nInstallations Completed\n"
            echo "saindo e finalizando..."
=======
            INSTALLING_PACKAGES && wait             # installing util packages and linux packages
            CHECKING_STAP_AVAILABLE && wait         # checking if stap available
            CONFIGURE_SYSTEMTAP_BINARIES && wait    # config depuration of systemtap
            DOWNLOADING_VIRTUALBOX                  # download virtualbox

            sleep 3

            apt update
            
            echo -e "\nInstallations Completed\n"
            echo "saindo e finalizando..."
            sleep 2
>>>>>>> d54b82f164400de4e96bc7a84b9549c8f1c4c627
            exit 0
            ;;

        *)
            echo "ERROR: error identifying the distribution"
            exit 1
            ;;
    esac
<<<<<<< HEAD
}
=======
}
######################################## END PRINCIPAL PROGRAM
>>>>>>> d54b82f164400de4e96bc7a84b9549c8f1c4c627
