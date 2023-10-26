#!/usr/bin/env bash

############################## START VARS CONFIG
# deprecated
# UUIDS="$(vboxmanage list hdds | sed -e '/./{H;$!d;}' -e 'x;/'"$GUEST"'/!d;' | grep UUID | egrep -v Parent | awk '{print $2}')"

# new
UUIDS_DISKS="$(vboxmanage list hdds | grep -w "UUID:" | grep -v "Parent UUID:" | awk '{print $2}')" # get 'UUID' with 'id' and remove 'Parent UUID'
############################## END VARS CONFIG

############################## START FUNCTIONS
REMOVING_DISKS() {
    for uuid_disk in $UUIDS_DISKS; do
        echo -e "\n--->> Deleting disk with id: $uuid_disk \n"
        deleting_disk="$(vboxmanage closemedium disk "$uuid_disk" --delete 2>&1)"

        if [[ "$deleting_disk" == *"error:"* ]]; then
            echo -e "Error: Failed to delete medium with UUID: $uuid_disk \n"
            echo -e "***\nDetails: \n$deleting_disk \n***"
        else
            echo "Medium with UUID = $uuid_disk ( deleted successfully )"
        fi
    done
}
############################## END FUNCTIONS

REMOVING_DISKS # using function
