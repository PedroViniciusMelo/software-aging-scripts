#!/usr/bin/env bash

######################################## START GLOBAL VARS CONFIG
[[ "$EUID" -ne 0 ]] && echo "Run Script as Super Administrator ( need root )" && exit 1
######################################## END GLOBAL VARS CONFIG

######################################## START FUNCTIONS

# FUNCTION == VERIFY_DISTRIBUTION
# DESCRIPTION == verify linux distribution and get id of distribution
VERIFY_DISTRIBUTION() {
    if [[ -f "/etc/os-release" ]]; then
        . /etc/os-release
        DISTRIBUTION_ID=$ID
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

# FUNCTION == INSTALLING_SYSTEMTAP_WITH_KERNEL_HEADERS
# DESCRIPTION == install systemtap with current kernel configuration headers on the machine
#
# EXAMPLE:
#   uname -r:
#       6.1.0-13-amd64
INSTALLING_SYSTEMTAP_WITH_KERNEL_HEADERS() {
    echo "INSTALLING SYSTEMTAP WITH KERNEL HEADERS:"
    apt install systemtap linux-headers-"$(uname -r)"
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
######################################## END FUNCTIONS

VERIFY_DISTRIBUTION    # get id of machine dist

######################################## START PRINCIPAL PROGRAM
case $DISTRIBUTION_ID in
    "debian")
        VERIFY_SYSTEMTAP_INSTALLED && wait
        INSTALLING_SYSTEMTAP_WITH_KERNEL_HEADERS && wait
        CHECKING_STAP_AVAILABLE && check=$(echo $#) && wait
        VERIFY_STATUS "$check"
        ;;

    *)
        echo "ERROR: error identifying the distribution"
        exit 1
        ;;
esac
######################################## END PRINCIPAL PROGRAM


# retirar warning de kernel: https://man7.org/linux/man-pages/man7/warning::symbols.7stap.html
# copie os binarios do /proc/kallsysms para /boot/System.map$(uname -r)
# cp /proc/kallsyms /boot/System.map-$( uname -r )