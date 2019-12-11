#!/usr/bin/env bash

mkdir docs/2_20_tmp
(cd docs/2_20; tar cf - .) | (cd docs/2_20_tmp; tar xvf - )
python link_to_latest.py docs/2_20_tmp/stan-users-guide "Stan User's Guide"
python link_to_latest.py docs/2_20_tmp/reference-manual "Stan Reference Manual"
python link_to_latest.py docs/2_20_tmp/functions-reference "Stan Functions Reference"
mv docs/2_20 docs/2_20_bak
mv docs/2_20_tmp/ docs/2_20
