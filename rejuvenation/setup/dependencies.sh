#!/usr/bin/env bash

######################################## START GLOBAL VARS CONFIG
[[ "$EUID" -ne 0 ]] && echo "Run Script as Super Administrator ( need root )" && exit 1

DISTR_CODENAME=$(
    cat </etc/os-release | grep -w "VERSION_CODENAME" | awk -F= '{print $2}'
    bookworm
)

DISTR_ID=$(cat </etc/os-release | grep -w "ID" | awk -F= '{print $2}')
######################################## END GLOBAL VARS CONFIG

######################################## START FUNCTIONS

# FUNCTION == VERIFY_DISTRIBUTION
# DESCRIPTION == verify linux distribution and get id of distribution
VERIFY_DISTRIBUTION() {
    if [[ -f "/etc/os-release" ]]; then
        DISTRIBUTION_ID=$DISTR_ID
        return 0
    else
        echo "ERROR: error when obtaining the machine's distro id"
        exit 1
    fi
}

# FUNCTION == VERIFY_SYSTEMTAP_INSTALLED
# DESCRIPTION == checks if the systemtap stap command is available and running
#
# RETURNS:
#   if command available:
#       exit 0
#   else:
#       return 1
VERIFY_SYSTEMTAP_INSTALLED() {
    if command -v stap &>/dev/null; then
        echo -e "\nsystemtap ja esta instalado\n"
        exit 0
    else
        echo -e "\nsystemtap nao esta instalado\n"
        return 1
    fi
}

# FUNCTION == INSTALLING_SYSTEMTAP_WITH_KERNEL_HEADERS_DEBUG_SYMBOLS
# DESCRIPTION == install systemtap with current kernel configuration headers and debug symbols on the machine
#
# EXAMPLE:
#   uname -r:
#       6.1.0-13-amd64
INSTALLING_SYSTEMTAP_WITH_KERNEL_HEADERS_DEBUG_SYMBOLS() {
    echo "INSTALLING SYSTEMTAP WITH KERNEL HEADERS AND DEBUG SYMBOLS:"
    apt install systemtap linux-headers-"$(uname -r)"
    apt install systemtap linux-image-"$(uname -r)"-dbg
    return 0
}

# FUNCTION == CHECKING_STAP_AVAILABLE
# DESCRIPTION == checking stap command availability
CHECKING_STAP_AVAILABLE() {
    echo -e "\nEXECUTING THE STAP COMMAND:"
    stap -v -e 'probe oneshot { println("hello world") }'
    return 0
}

# FUNCTION == VERIFY_STATUS
# DESCRIPTION == checks exit status of CHECKING_STAP_AVAILABLE
#
# RETURNS:
#   if status == 0:
#       exit 0
#   else:
#       exit 1
VERIFY_STATUS() {
    status=$1
    if [[ $status -eq 0 ]]; then
        echo -e "\nWarning: Success When Running stap, Installation Completes Successfully\n"
        exit 0
    else
        echo -e "\nWarning: Stap Command Unavailable, Error Occurred When Installing/Running SystemTap\n"
        exit 1
    fi
}

# FUNCTION == CONFIGURE_SYSTEMTAP_BINARIES
# DESCRIPTION:
#   Systemtap may need a linux-build style System.map file to find kernel function/data addresses.
#   It may be possible to create it manually
#
# REFERENCES:
#   https://man7.org/linux/man-pages/man7/warning::symbols.7stap.html
CONFIGURE_SYSTEMTAP_BINARIES() {
    cp /proc/kallsyms /boot/System.map-"$(uname -r)"
}

INSTALLING_GNUPG_WGET_CURL_SYSSTAT() {
    apt-get install gnupg wget curl sysstat -y
}

ADD_REPOSITORY_VIRTUALBOX() {
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian $DISTR_CODENAME contrib" >/etc/apt/sources.list
}

REMOVE_OLD_KEYS_ORACLE() {
    apt-key remove 5CDFA2F683C52980AECF
    apt-key remove D9C954422A4B98AB5139

}

DOWNLOADING_REGISTERING_PUBLIC_KEY_VIRTUALBOX() {
    wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg
}

DOWNLOADING_VIRTUALBOX() {
    apt-get update
    apt-get install virtualbox-7.0 -y
}

HANDLE_INVALID_ASSIGNATURE_ERRORS_VIRTUALBOX() {
    sudo -s -H
    apt-get clean
    rm /var/lib/apt/lists/*
    rm /var/lib/apt/lists/partial/*
    apt-get clean
    apt-get update

}

######################################## END FUNCTIONS

VERIFY_DISTRIBUTION # get id of machine dist

######################################## START PRINCIPAL PROGRAM
case $DISTRIBUTION_ID in
"debian")
    VERIFY_SYSTEMTAP_INSTALLED && wait
    INSTALLING_SYSTEMTAP_WITH_KERNEL_HEADERS_DEBUG_SYMBOLS && wait
    CHECKING_STAP_AVAILABLE && check=$(echo $#) && wait
    VERIFY_STATUS "$check"
    CONFIGURE_SYSTEMTAP_BINARIES
    ;;

*)
    echo "ERROR: error identifying the distribution"
    exit 1
    ;;
esac
######################################## END PRINCIPAL PROGRAM
