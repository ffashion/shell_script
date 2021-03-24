#!/bin/bash
export sshDir=~/.ssh
export etcDir=~/.etc
export line_num=`sed -n '$=' ${etcDir}/serverList`
echoColor(){
    case $1 in 
        "r")
            echo -e "\033[31m $2\033[0m"
            ;;
        "g")
            echo -e "\033[32m $2\033[0m"
            ;;
        "bl")
            echo -e "\033[36m $2\033[0m"
            ;;
        *)
            echo "color select error"
            ;;
    esac
}
useage() {
	echo "For example :"
	echo "admin add ssh rasp:root@192.168.123.1"
    echo "admin rm ssh s0"
}
checkEnv(){
    mkdir -p ${etcDir}
    touch ${etcDir}/serverList
}
searchServer(){
    echo ""
}
getServerList(){
    echo "你拥有下列服务器"
    checkEnv
    cat ${etcDir}/serverList
}
getServerIdMaxByGroup(){
    checkEnv
    export serverIdMaxByGroup=`cat ${etcDir}/serverList | grep -e "^$1[0-9]" | wc -l`
}

createMainPrivateFile(){
    ssh-keygen -t rsa -b 4096 -C `echo ${3}-$(whoami)` -f ${sshDir}/`echo ${group}`:main_id_rsa
}

addSSHServer(){
    echo ""
}
searchServer(){
    echo ""
}

case $1 in 
    "add")
        case $2 in
            "ssh")
                export group=`echo $3 | grep -oe "^[a-zA-Z]*"`
                export server=`echo $3 |  sed s/$group://`
                getServerIdMaxByGroup $group
                export rsa_file=${sshDir}/${group}${serverIdMaxByGroup}:${server}_id_rsa
                export pub_file=${sshDir}/${group}${serverIdMaxByGroup}:${server}_id_rsa.pub
                if [ "$serverIdMaxByGroup" -eq 0 ];then
                    createMainPrivateFile
                    ln -s ${sshDir}/${group}:main_id_rsa     ${rsa_file}
                    ln -s ${sshDir}/${group}:main_id_rsa.pub ${pub_file}
                else 
                    ln -s ${sshDir}/${group}:main_id_rsa      ${rsa_file}
                    ln -s ${sshDir}/${group}:main_id_rsa.pub  ${pub_file}
                fi
                
                ssh-copy-id -f -i ${sshDir}/${group}:main_id_rsa ${server}
                if [ $? -eq 0 ];then
                    echoColor g "add Server成功"
                    echo "${group}${serverIdMaxByGroup}:${server}" >> ${etcDir}/serverList
                else
                    echoColor r "add Server失败"
                    rm -rf ${rsa_file} ${pub_file}
                fi
                
            ;;
            *)
                echoColor bl "完善中"
            ;;
        esac
    ;;
    "search")   
         for i in ${sshDir}/*[[:digit:]]*id_rsa ;do
                [ -e "$i" ] || continue
                #目录包含斜线，注意使用#
                list=`echo $i | sed s#${sshDir}/##`
                echo $list
         done

    ;;
    "update")
        mv ${etcDir}/serverList ${etcDir}/serverList.backup 
        for i in ${sshDir}/*[[:digit:]]*id_rsa ;do
                 [ -e "$i" ] || continue  
                list=`echo $i | sed s#${sshDir}/## | sed s/_id_rsa$//`
                echo ${list} >> ${etcDir}/serverList
        done

    ;;
    "rm")
        case $2 in 
            "ssh")
                for ((i=1;i<=$line_num;i++));do
                    server_mask=`sed -n "${i}p" ${etcDir}/serverList | xargs -d: echo -n | awk '{ print $1 }'`
                    server=`sed -n "${i}p" ${etcDir}/serverList | xargs -d: echo -n | awk '{ print $2 }'`
                    if [ x$server_mask == x${3} ] ;then 
                        echoColor r "正在删除 ${sshDir}/${server_mask}:${server}_id_rsa"
                        rm -rf ${sshDir}/${server_mask}:${server}_id_rsa
                        rm -rf ${sshDir}/${server_mask}:${server}_id_rsa.pub
                        admin updtae
                        admin sort
                        break;
                    else 
                            continue;
                    fi
                done
            ;;
            
            *)
                echo "完善中"
            ;;
        esac
    ;;
    "modify")
         echo "完善中"
    ;;
    "ssh")
		for ((i=1;i<=$line_num;i++));do
				server_mask=`sed -n "${i}p" ${etcDir}/serverList | xargs -d: echo -n | awk '{ print $1 }'`
				server=`sed -n "${i}p" ${etcDir}/serverList | xargs -d: echo -n | awk '{ print $2 }'`
				if [ x$server_mask == x${2} ] ;then 
        			ssh -i "${sshDir}/${2}:${server}_id_rsa" ${server}
                    break;
				else 
						continue;
				fi
		done

    ;;
    "mysql")
        echo "完善中"
    ;;
    "list")
        getServerList
    ;;
    "sort")
        sort ${etcDir}/serverList -o ${etcDir}/serverList
    ;;
	"--help")
			useage
	;;
    "help")
            useage
    ;;
    *)
        echoColor r "Error: parameter one error or null"
    ;;
esac
