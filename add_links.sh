#!/usr/bin/env bash

### USAGE
# add_links.sh major minor
# Example:
# add_links.sh 2 22

major="$1"
minor="$2"

if [ -z "$major" ] || [ -z "$minor" ]
then
      echo "Major, minor required."
      exit 0
fi

directory="$major""_""$minor"

mkdir docs/"$directory"_tmp

(cd docs/"$directory"; tar cf - .) | (cd docs/"$directory"_tmp; tar xvf - )

python link_to_latest.py docs/"$directory"_tmp/stan-users-guide "Stan User's Guide"
python link_to_latest.py docs/"$directory"_tmp/reference-manual "Stan Reference Manual"
python link_to_latest.py docs/"$directory"_tmp/functions-reference "Stan Functions Reference"

mv docs/"$directory" docs/"$directory"_bak
mv docs/"$directory"_tmp/ docs/"$directory"

rm -r "$directory"_tmp