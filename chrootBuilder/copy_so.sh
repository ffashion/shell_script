
copy_file(){
    mkdir -p .`dirname $1`
    #如果使用-r 那么如果文件时软连接的话 只会复制软链接 并不会复制真正的文件
    cp -u $1 .$1
}

copy_command_lib(){
    # ldd $1 1>/dev/null 2>/dev/null || echo -n "static"
    #LIB为命的的库绝对路径
    LIB=`ldd $1 2>/dev/null| grep 'lib.*=>.*' | awk  '{print $3}'`
    for i in $LIB;do
        echo "copy lib" $i
        copy_file $i
    done
}

copy_command(){
    copy_file $1
}


if [ $# -ne 1 ]; then
    echo "need a command"
    exit 1
fi

absulute_path=`whereis -b $1 | awk '{ print $2}'`
[[ $absulute_path == "" ]] && echo $i "command not found " && continue

echo "copy" $absulute_path
copy_command $absulute_path
copy_command_lib $absulute_path
