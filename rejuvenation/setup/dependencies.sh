#!/usr/bin/env bash

######################################## START ERROR HANDLING
error_exit() {
    echo -e "$1" >&2
    return "${2:-1}"
}
######################################## END ERROR HANDLING

######################################## START GLOBAL VARS CONFIG
[[ "$EUID" -ne 0 ]] && echo "Run Script as Super Administrator ( need root )" && exit 1

OS_RELEASE=/etc/os-release

KERNEL_VERSION=$(uname -r)

# DISTR_CODENAME=$(cat <"$OS_RELEASE" | grep -w "VERSION_CODENAME" | awk -F= '{print $2}')

DISTR_ID=$(cat <"$OS_RELEASE" | grep -w "ID" | awk -F= '{print $2}')
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
        return 0
    else
        error_exit "\nERROR: error when obtaining the machine's distro id\n"
    fi
}

CHECK_INSTALLED_PACKAGES() {
    local package=$1

    dpkg -s "$package" &>/dev/null

    if [[ $? -eq 0 ]]; then
        return 0
    else
        return 1
    fi
}

INSTALLING_PACKAGES() {
    if CHECK_INSTALLED_PACKAGES "$1"; then
        echo -e "\npackage $1 is already installed\n"
        return 0
    else
        echo -e "\ninstalling package $1 \n"
        apt install "$1" -y
    fi
}

# FUNCTION == CHECKING_STAP_AVAILABLE
# DESCRIPTION == checking stap command availability
CHECKING_STAP_AVAILABLE() {
    if command -v stap &>/dev/null; then
        echo -e "\nsystemtap is already installed\n"
        echo -e "\nEXECUTING THE STAP COMMAND:"

        stap -v -e 'probe oneshot { println("hello world") }'

        return 0
    else
        error_exit "\nsystemtap is not installed\n"
    fi
}

# FUNCTION == VERIFY_STATUS
# DESCRIPTION == checks exit status of CHECKING_STAP_AVAILABLE
#
# RETURNS:
#   if status == 0:
#       exit 0
#   else:
#       exit 1
CHECK_IF_INSTALLED_PACKAGES() {
    local systemtap=$1
    local linux_headers=$2
    local linux_debug_image=$3
    local stap_available=$4

    if [[ $systemtap -eq 0 ]]; then
        echo -e "\nWarning: systemtap installed successfully\n"
    else
        echo -e "\nWarning: error during systemtap installation\n"
        exit 1
    fi

    if [[ $linux_headers -eq 0 ]]; then
        echo -e "\nWarning: linux headers installed successfully\n"
    else
        echo -e "\nWarning: error during linux headers installation\n"
        exit 1
    fi

    if [[ $linux_debug_image -eq 0 ]]; then
        echo -e "\nWarning: linux debug image installed successfully\n"
    else
        echo -e "\nWarning: error during linux debug image installation\n"
        exit 1
    fi

    if [[ $stap_available -eq 0 ]]; then
        echo -e "\nWarning: stap available successfully\n"
    else
        echo -e "\nWarning: error during stap executing\n"
        exit 1
    fi
}

# FUNCTION == CONFIGURE_SYSTEMTAP_BINARIES
# DESCRIPTION == Systemtap may need a linux-build style System.map file to find kernel function/data addresses.
#   It may be possible to create it manually
#
# REFERENCES:
#   https://man7.org/linux/man-pages/man7/warning::symbols.7stap.html
CONFIGURE_SYSTEMTAP_BINARIES() {
    echo -e "\nconfiguring debug binaries for systemtap...\n"
    cp /proc/kallsyms /boot/System.map-"$(uname -r)"
    sleep 2

    if [[ $? -eq 0 ]]; then
        echo -e "\nSUCCESS: successfully configured!\n"
        return 0
    else
        echo -e "\nERROR: configuration of systemtap debug binaries failed\n"
        exit 1
    fi
}

# FUNCTION == DOWNLOADING_VIRTUALBOX
# DESCRIPTION == downloading of virtualbox-7.0
DOWNLOADING_VIRTUALBOX() {
    mkdir -p virtualBox
    sleep 2

    if [[ -f "./virtualBox/virtualbox-7.0_7.0.10-158379~Debian~bookworm_amd64.deb" ]]; then
        echo -e "\nfile already downloaded\n"

        echo -e "\nERROR: Trying to resolve virtualbox dependencies\n"

        apt-get -y -f install


        if [ $? -ne 0 ]; then
            echo "Unable to resolve dependencies automatically. Please install dependencies manually."
            exit 1
        else
            echo "Dependencies resolved. Trying to install VirtualBox again..."
            cd ./virtualBox && dpkg -i virtualbox-7.0_7.0.10-158379~Debian~bookworm_amd64.deb
            if [ $? -ne 0 ]; then
                echo "Still unable to install VirtualBox. Please check for errors and resolve them manually."
                exit 1
            fi
        fi

    else
        wget -P ./virtualBox https://download.virtualbox.org/virtualbox/7.0.10/virtualbox-7.0_7.0.10-158379~Debian~bookworm_amd64.deb
        cd ./virtualBox && dpkg -i virtualbox-7.0_7.0.10-158379~Debian~bookworm_amd64.deb

        if [[ $? -ne 0 ]]; then
            echo -e "\nERROR: Trying to resolve virtualbox dependencies\n"

            apt-get -y -f install

            if [ $? -ne 0 ]; then
                echo "Unable to resolve dependencies automatically. Please install dependencies manually."
                exit 1
            else
                echo "Dependencies resolved. Trying to install VirtualBox again..."
                cd ./virtualBox && dpkg -i virtualbox-7.0_7.0.10-158379~Debian~bookworm_amd64.deb
                if [ $? -ne 0 ]; then
                    echo "Still unable to install VirtualBox. Please check for errors and resolve them manually."
                    exit 1
                fi
            fi
        fi
    fi
}
######################################## END FUNCTIONS

######################################## START PRINCIPAL PROGRAM
VERIFY_DISTRIBUTION # get id of machine dist
case $DISTRIBUTION_ID in
"debian")
    clear
    ############################################ START GENERAL INSTALLATIONS AND CONFIGS
    # installing util packages
    INSTALLING_PACKAGES "gnupg"
    INSTALLING_PACKAGES "wget"
    INSTALLING_PACKAGES "curl"
    INSTALLING_PACKAGES "sysstat"

    # systemtap:
    #   install SystemTap which is a tool that allows you to monitor and debug systems in real time
    INSTALLING_PACKAGES "systemtap" && systemtap_status=$(echo $?) && wait # install systemtap

    # linux headers:
    #   install kernel headers that match the kernel version currently running on the system
    INSTALLING_PACKAGES linux-headers-"$KERNEL_VERSION" && linux_headers_status=$(echo $?) && wait # install linux headers

    # linux image:
    #   Download the kernel debug image corresponding to the machine's current kernel version.
    #       This allows you to use SystemTap to debug the kernel and analyze the inner workings of the system.
    INSTALLING_PACKAGES linux-image-"$KERNEL_VERSION"-dbg && linux_debug_image_status=$(echo $?) && wait # install linux images

    CHECKING_STAP_AVAILABLE && stap_status=$(echo $?) && wait

    CHECK_IF_INSTALLED_PACKAGES "$systemtap_status" "$linux_headers_status" "$linux_debug_image_status" "$stap_status"

    CONFIGURE_SYSTEMTAP_BINARIES
    ############################################ END GENERAL INSTALLATIONS AND CONFIGS

    ############################################ START VIRTUALBOX INSTALLATION AND CONFIGS
    DOWNLOADING_VIRTUALBOX
    ############################################ END VIRTUALBOX INSTALLATION AND CONFIGS

    sleep 3
    apt update && echo -e "\nInstallations Completed\n"
    ;;

*)
    echo "ERROR: error identifying the distribution"
    exit 1
    ;;
esac
######################################## END PRINCIPAL PROGRAM
