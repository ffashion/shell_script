if [[ x"$1" == x"" ]]; then 
		echo "请输入server参数" 
elif [[ x"$1" != x"s""[0-9]*" ]] ;then 
	echo "Server不存在,Server以s开头数字结尾。"
fi
s=(root@zqa.me root@tc.askaskask.cn)

for i in ${!s[@]} ; do
	if [[ x"$1" == x"s"$i ]]; then 
			ssh ${s[$i]} ; 
	fi
done


