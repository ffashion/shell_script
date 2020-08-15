#!/bin/bash
s=()
getList(){
                echo "你拥有下列服务器"
                # 这里的i从0到开始增加
                for i in ${!s[@]} ; do
                                echo -n "s"$i":"
                                echo ${s[$i]};
                done
}
getHelp(){
                echo "第一个参数为command，它可以是list help add del mysql ssh等"
                echo "第二个参数为服务器的地址，以s开头 数字结尾" 
}
searchSSHServer(){
        echo "完善中"
}
addSshServer(){
        sed  -i "s/^s=(\(.*[[:space:]]\)\{0,\}/&`echo -n $1` /g" `echo $0`
        echo "已经添加$1,请使用admin list查看"
}
#addSSHServer servername ~
addSSHServer(){
        echo -en "选择您的添加模式\n(1)生成公私钥\n(2)软链接:"
        read -p "" private_key
        if [ x"1" = x"$private_key" ]; then
                echo "正在生成特定机器的公私钥,将存储在~/.ssh/$1_id_rsa 和 $1_id_rsa.pub"
                # 判断文件是否存在，软链接或者普通文件
                if [ -e  ~/.ssh/${1}_id_rsa ]; then 
                        echo "此Server公私钥已存在，跳过创建";
                        read -p "是否删除已存在的公私钥(y/n):" var
                        if [ x"$var" = xy ] || [ x"$var" == xY ];then 
                                        rm -rf $2/.ssh/{$1_id_rsa.pub,$1_id_rsa};
                                        echo "删除成功" 
                        elif [ x"$var" = xn ] || [ x"$var" = xN ];then 
                                        echo "已取消删除"
                        else
                                        echo "请输入(y|Y)|(n|N)"
                        fi
                        unset var
                else
                        ssh-keygen -t rsa -b 4096 -C `echo ${1}-$(whoami)` -f ~/.ssh/`echo "$1"`_id_rsa
                        echo "上传公钥文件";
                        # $2 == ~
                        ssh-copy-id -f -i "${2}/.ssh/$1_id_rsa.pub" "$1"
                                if [ $? -eq 0 ] ; then  
                                        # &表示引用前面的pattern
                                        sed  -i "s/^s=(\(.*[[:space:]]\)\{0,\}/&`echo -n $1` /g" `echo $0`
                                        echo "已经添加$1,请使用admin list查看"
                                else 
                                        rm -rf $2/.ssh/{$1_id_rsa.pub,$1_id_rsa}
                                        echo "Error Accure"
                                fi

                        

                fi
        
        elif [ x"2" = x"$private_key" ]; then
                if [ -f  ${2}/.ssh/${1}_id_rsa ]; then 
                        read -p "私钥已存在,是否重新设置软链接(y/n):" var
                        if [ x"$var" = x"y" ];then 
                                rm -rf ${2}/.ssh/${1}_id_rsa
                                read -p "设置私钥软链接(默认为~/.ssh/id_rsa)" private_file
                                if [ x"$private_file" = ${2}/.ssh/id_rsa ];then 
                                        ln -s ${2}/.ssh/id_rsa ${2}/.ssh/${1}_id_rsa
                                else
                                        ln -s $private_file ${2}/.ssh/${1}_id_rsa
                                        if [ $? -eq 0 ];then 
                                                echo "软链接成功"
                                        else  
                                                echo "软链接失败,请检查"
                                        fi
                                fi


                        elif [ x"$var" = x"n" ];then
                                echo "quiting" 
                                exit 0         
                        else   
                                exit -1
                        fi
                else
                        read -p "设置私钥软链接(默认为~/.ssh/id_rsa)" private_file
                        if [ x"$private_file" = x"" ];then
                                ln -s ${2}/.ssh/id_rsa ${2}/.ssh/${1}_id_rsa
                                if [ $? -eq 0 ];then 
                                        echo "软链接成功"
                                        addSshServer $1
                                else  
                                        echo "软链接失败,请检查"
                                fi
                        else
                                ln -s $private_file ${2}/.ssh/${1}_id_rsa
                                if [ $? -eq 0 ];then 
                                        echo "软链接成功"
                                        addSshServer $1
                                else  
                                        echo "软链接失败,请检查"
                                fi
                        fi    
                fi
        else  
                echo "请选择1或者2"
        fi

        
}
#delSSHServer servername
delSSHServer(){ 
        #if [[ x"s"]]
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
                ssh -i ~/.ssh/${s[$i]}_id_rsa ${s[$i]};
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
                addSSHServer "$3" ~
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


# 制作一个软链接函数
# 制作一个echo 颜色函数
