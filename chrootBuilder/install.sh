SYSTEM_VERSION=`cat /etc/issue`
# [[ $SYSTEM_VERSION =~ "Ubuntu" ]] && SYSTEM_VERSION=Ubuntu

case $SYSTEM_VERSION in
    *"Ubuntu"*)
        cd chroot && ../debian.sh
        ;;
esac

