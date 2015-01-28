#!/bin/bash

# Copyright (C) 2015, Moule Corp <greezly@moulecorp.org>

base=$1
from=$2
to=$3

git checkout $base Makefile
cp Makefile Makefile.base
git checkout $from Makefile
cp Makefile Makefile.from
git checkout HEAD Makefile
git merge-file --ours Makefile Makefile.base Makefile.from
rm -f Makefile.base Makefile.from
git add Makefile
