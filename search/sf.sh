
#!/bin/bash
# sf = search file

if [ $# -ne 2 ]; then
  echo "Usage: $0 directory string"
  exit 1
fi

dir=$1
str=$2

if [ ! -d "$dir" ]; then
  echo "Error: $dir is not a valid directory"
  exit 1
fi

find "$dir" -type f -name "*$str*" -print

