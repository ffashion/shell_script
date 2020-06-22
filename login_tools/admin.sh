#!/bin/bash
s=(root@zqa.me root@tc.askaskask.cn)
getList(){
		echo "你拥有下列服务器"
		for i in ${!s[@]} ; do 
				echo ${s[$i]};
		done
}
getHelp(){
		echo "第一个参数为command，它可以是list help add mysql ssh等"
		echo "第二个参数为服务器的地址，以s开头 数字结尾"
}

addServer(){
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
	addServer
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





		