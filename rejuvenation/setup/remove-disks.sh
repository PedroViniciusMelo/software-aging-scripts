UUIDS=`vboxmanage list hdds | sed -e '/./{H;$!d;}' -e 'x;/'"$GUEST"'/!d;'| grep UUID | egrep -v Parent| awk '{print $2}'`
for u in $UUIDS
do
 echo '--->> Deleteing: '$u
 vboxmanage closemedium disk $u --delete 
done
