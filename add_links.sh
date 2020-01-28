#!/usr/bin/env bash

### USAGE
# add_links.sh 

cd docs
# Count number of dirs in /docs
docsDirsCount=`find . -mindepth 1 -maxdepth 1 -type d | wc -l`
# Get last docs version
# Substract functions-reference, reference-manual, stan-users-guide, current version and remove trailing /
directory=`ls -d -- */ | sed -n "$(($docsDirsCount-4))"p | sed 's/.$//'`
cd ..

mkdir docs/"$directory"_tmp

(cd docs/"$directory"; tar cf - .) | (cd docs/"$directory"_tmp; tar xvf - )

python link_to_latest.py docs/"$directory"_tmp/stan-users-guide "Stan User's Guide"
python link_to_latest.py docs/"$directory"_tmp/reference-manual "Stan Reference Manual"
python link_to_latest.py docs/"$directory"_tmp/functions-reference "Stan Functions Reference"

mv docs/"$directory" docs/"$directory"_bak
mv docs/"$directory"_tmp/ docs/"$directory"

rm -r "$directory"_tmp