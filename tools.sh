#!/bin/bash
setEnv(){
		if [ ! -d ~/.bin ] ; then 
			mkdir ~/.bin
			PATH=$PATH:~/.bin
		fi
}
setEnv
for i in */*.sh ; do 
		[ -e $i ] || continue 
		echo $i
		file=$(echo $i | sed s/.sh//g | sed s#.*/##g) 
		echo $file
		cp  -- $i ~/.bin/$file
done

