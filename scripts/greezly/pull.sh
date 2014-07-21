#!/bin/bash

# Copyright (C) 2014, Antoine Tenart <atenart@n0.pe>

cd $(git rev-parse --show-toplevel)

V=$(ls .. | grep -E "grsecurity[0-9.-]+.patch")
if [ -z $V ]; then
	V=$(./scripts/greezly/find_out_grsecurity_version.pl)
fi

V=$(echo $V | sed 's/-/ /g' | sed 's/\(^grsecurity \|\.patch$\)//g')
./scripts/greezly/fetch_n_apply_grsecurity_patch.sh $V
