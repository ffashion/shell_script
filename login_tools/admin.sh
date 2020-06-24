#!/bin/bash
s=(root@zqa.me root@tc.askaskask.cn )
getList(){
                echo "你拥有下列服务器"
                for i in ${!s[@]} ; do
                                echo -n "s"$i":"
                                echo ${s[$i]};
                done
}
getHelp(){
                echo "第一个参数为command，它可以是list help add del mysql ssh等"
                echo "第二个参数为服务器的地址，以s开头 数字结尾"
}

addSSHServer(){
        # &表示引用前面的pattern
        sed  -i "s/^s=(\(.*[[:space:]]\)\{0,\}/&`echo -n $1` /g" `echo $0`
        echo "已经添加$1,请使用admin list查看"
}
delSSHServer(){
        # \1 \2 \3表示反向引用
        sed -i "s/\(s=(\)\(.*\)"$1" \(.*\)/\1\2\3/g" `echo $0`
}
addMYSQLServer(){
        echo "正在完善中"
}
delMYSQLServer(){
        echo "正在完善中"
}
sshAdmin(){
        for i in ${!s[@]} ; do
        if [[ x"$1" == x"s"$i ]]; then
                        ssh ${s[$i]} ;
        fi
        done
}
mysqlAdmin(){
        echo "正在完善中"
}
# main
# 帮助相关
if [[ x"$1" == x"" || x"$1" == x"help" ]]; then
        getHelp
elif [[ x"$1" == x"list" ]];then
        getList
fi
#addServer相关
if [[ x"$1" == x"add" ]];then
        if [[ x"$2" == x"ssh" ]];then
                if [[ x"$3" == x"" ]];then
                        echo "Server为空,请输入正确的Server"
                        exit -1;
                fi
                addSSHServer "$3"
        elif [[ x"$2" == x"mysql" ]];then
                if [[ x"$3" == x"" ]];then
                        echo "Server为空,请输入正确的Server"
                        exit -1;
                fi
                addMYSQLServer "$3"
        else
                        echo "请在del后面选择ssh或者mysql"
        fi
fi
#delServer相关
if [[ x"$1" == x"del" ]];then
        if [[ x"$2" == x"ssh" ]];then
                        delSSHServer "$3"
        elif [[ x"$2" == x"mysql" ]];then
                        delMYSQLServer
        else
                        echo "请在add后面选择ssh或者mysql"
        fi
fi
# ssh相关
if  [[ x"$1" == x"ssh" ]];then
        if [[ x"$2" == x"" ]];then
                echo "ssh Server未选择，请查看帮助手册"
                exit -1
        fi
        if [[ x"$2" != xs[0-9]* ]] ;then
                echo "Server输入不正确,Server必须以s开头 以数字结尾"
                exit -1
        fi
        sshAdmin "$2"

fi

# mysql相关
if [[ x"$1" == x"mysql" ]];then
        mysqlAdmin
fi