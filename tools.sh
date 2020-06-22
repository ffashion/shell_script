#!/bin/bash
setEnv(){
		if [ ! -d ~/.bin ] ; then 
			PATH=$PATH:~/.bin
		fi
}
for i in */*.sh ; do 
		[ -e $i ] || continue 
		setEnv
		echo $i
		file=$(echo $i | sed s/.sh//g | sed s#.*/##g) 
		echo $file
		cp  -- $i ~/.bin/$file
done

