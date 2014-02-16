#!/bin/bash

# Copyright (C) 2014, Antoine Tenart <atenart@n0.pe>

from=$1
to=$2

cd $(git rev-parse --show-toplevel)

git checkout $1
git merge -s ours --no-edit $2
git branch tmpMerge
git reset --hard $2
git reset --soft tmpMerge
git checkout $1 scripts/greezly arch/x86/configs/x86_64_greezly_defconfig
git commit --amend --no-edit
git branch -D tmpMerge
