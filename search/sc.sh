
# sc == search content
if [ $# -lt 2 ]; then
    echo "Usage :$0 path_to_search search_string [include_pattern] [exclude_pattern]"
    exit 1
fi

path_to_search="$1"
search_string="$2"
include_pattern="$3"
exclude_pattern="$4"

if [ -n "$include_pattern" ]; then
    include_pattern=$(echo "$include_pattern" | sed 's/,/ --include=/g')
    include_pattern="--include=$include_pattern"
fi


if [ -n "$exclude_pattern" ]; then
    exclude_pattern=$(echo "$exclude_pattern" | sed 's/,/ --exclude=/g')
    exclude_pattern="--exclude=$exclude_pattern"
fi


grep_cmd="grep -r --color=always $include_pattern $exclude_pattern '$search_string' $path_to_search"


eval $grep_cmd


