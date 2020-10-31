
x=1
y=300

for i in {0..18}; do
		tmpx=$((x+300*i))
		tmpy=$((y+300*i))
		sed -n  "${tmpx},${tmpy}p" 5500_all.txt > ${tmpy}.txt
		echo "${tmpy}生成完毕"
done
