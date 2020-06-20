if [[ x"$1" == x"" ]]; then 
		echo "请输入server参数" 
fi
s=(root@zqa.me root@tc.askaskask.cn)

for i in ${!s[@]} ; do
	if [[ x"$1" == x"s"$i ]]; then 
			ssh ${s[$i]} ; 
	fi
done

