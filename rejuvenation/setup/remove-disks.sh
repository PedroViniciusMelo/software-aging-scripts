#!/usr/bin/env bash

############################## VARS CONFIG
UUIDS="$(vboxmanage list hdds | sed -e '/./{H;$!d;}' -e 'x;/'"$GUEST"'/!d;' | grep UUID | egrep -v Parent | awk '{print $2}')"

############################## START FUNCTIONS
REMOVING_DISKS() {
    for u in $UUIDS; do
        echo '--->> Deleteing: '"$u"
        vboxmanage closemedium disk "$u" --delete
    done
}

############################## END FUNCTIONS
