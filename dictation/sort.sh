sort 5500_all.txt > sort/5500_all_sort.txt
for i in {300..5700..300};do
		sort ${i}.txt > sort/${i}_sort.txt
done
