#!/bin/bash
export sshDir=~/.ssh
export etcDir=~/.etc
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
                    echo "add Server成功"
                    echo "${group}${serverIdMaxByGroup}:${server}" >> ${etcDir}/serverList
                else
                    echo "add Server失败"
                    rm -rf ${rsa_file} ${pub_file}
                fi
                
            ;;
            *)
                echo "完善中"
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
    "del")
        echo "完善中"
    ;;
    "modify")
         echo "完善中"
    ;;
    "ssh")
        server=`cat ${etcDir}/serverList | grep $2 | sed "s/^${2}://"`
        ssh -i "${sshDir}/${2}:${server}_id_rsa" ${server}
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
    *)
        echo "parameter one error or null"
    ;;
esac
