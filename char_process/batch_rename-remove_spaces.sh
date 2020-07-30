for i in * ; do
		[ -e "$i" ] || continue #continue跳出for循环
		no_space_i=`echo "$i" | sed s/[[:space:]]//g`
		echo "$no_space_i"
		if [[ "$i" != "$no_space_i" ]]; then 
			mv -- "$i" "$no_space_i"  # -- 可以防止文件名里面有- 造成参数解析错误
		fi
done
