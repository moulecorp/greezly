#!/bin/bash

# Copyright (C) 2015, Moule Corp <greezly@moulecorp.org>

from=$1
to=$2
base=$3

cd $(git rev-parse --show-toplevel)

git checkout $from
git merge -s ours --no-edit $to
git branch tmpMerge
git reset --hard $to
git reset --soft tmpMerge
git checkout $from scripts/greezly arch/x86/configs/x86_64_greezly_defconfig

./scripts/greezly/keep_ours.sh $base $from $to

git commit --amend --no-edit
git branch -D tmpMerge
