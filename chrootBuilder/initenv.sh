create_file(){
    echo "create sys file"
    mkdir -p /{root,dev,usr,etc,home}
    mknod -m  666 /dev/null c 1 3
    mknod -m  666 /dev/tty c 5 0
    mknod -m  666 /dev/zero c 1 5
    mknod -m  666 /dev/random c 1 8
}

create_file
