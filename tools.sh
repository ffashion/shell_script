#!/bin/bash 
setEnv(){
		rm -rf $1/.bin 
		if [ ! -d ~/.bin ] ; then 
			mkdir ~/.bin
			echo "PATH="$PATH:~/.bin"" >> ~/.bashrc
			PATH=$PATH:$1/.bin
		fi
}
setEnv ~
for i in */*.sh ; do 
		[ -e $i ] || continue 
		echo $i
		file=$(echo $i | sed s/.sh//g | sed s#.*/##g) 
		echo $file
		cp  -- $i ~/.bin/$file
done

