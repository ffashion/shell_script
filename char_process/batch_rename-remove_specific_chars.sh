useage(){
		echo "用法错误，请参考以下介绍"
		echo 第一个参数为你修改前的字符串，且必须存在。
		echo 第二个参数为你修改后的字符串，可以为空，为空表示删除修改前的字符串
}
for i in * ; do
		[ -e "$i" ] || continue
		if [[ x"$1" == x"" ]] ; then 
				useage
				exit -1
		fi
		no_spec_char=$( echo "$i" | sed s/`echo "$1"`/`echo "$2"`/g )
		mv -- "$i" "$no_spec_char"
done

