for i in {300,5700,300};do
		shuf  ${i}.txt > ${i}.txt.tmp
		mv ${i}.txt.tmp ${i}.txt
done
