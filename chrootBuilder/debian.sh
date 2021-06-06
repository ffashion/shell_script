export command_list=("bash" "ls" "dpkg" "apt" "whoami" "whereis" "vim" "cat" "grep" "awk" "adduser" "groups" "perl" "su" "sudo" "passwd" "id" "mknod" "rm" "cp" "mv" "file" "mkdir"
)
create_file(){
    echo "create sys file"
    mkdir -p ./{root,dev,usr,etc,home}
}

copy_file(){
    mkdir -p .`dirname $1`
    #如果使用-r 那么如果文件时软连接的话 只会复制软链接 并不会复制真正的文件
    cp -u $1 .$1
}
copy_dir(){
    mkdir -p .`dirname $1`
    cp -ru $1 .$1
}

copy_command_lib(){
    # ldd $1 1>/dev/null 2>/dev/null || echo -n "static"
    #LIB为命的的库绝对路径
    LIB=`ldd $1 2>/dev/null| grep 'lib.*=>.*' | awk  '{print $3}'`
    for i in $LIB;do
        copy_file $i
    done
}
copy_command(){
    copy_file $1
}

copy_bash_conf(){
    echo "copy bash_conf ..."
    copy_file /etc/{profile,bash.bashrc}
    copy_file /etc/bash_completion
    copy_file /etc/passwd
    copy_file /usr/share/bash-completion/bash_completion
    copy_dir /etc/bash_completion.d
    
    
}
copy_system_conf(){
    echo "copy system_conf ..."
    copy_file /etc/hosts
    copy_file /home/fashion/.bashrc 
}

copy_common_lib(){
    copy_file /lib64/ld-linux-x86-64.so.2
}


create_file
copy_common_lib
copy_bash_conf
copy_system_conf

#循环复制数组中的命令 以及命令依赖的so
for i in ${command_list[*]};do
    absulute_path=`whereis -b $i | awk '{ print $2}'`
    [[ $absulute_path == "" ]] && echo $i "command not found " && continue
    
    echo "copy" $absulute_path
	copy_command $absulute_path
    copy_command_lib $absulute_path
done
cd ..
cp ./initenv.sh ./chroot



