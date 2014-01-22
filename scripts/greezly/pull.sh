#!/bin/bash

# Copyright (C) 2014, Antoine Tenart <atenart@n0.pe>

cd $(git rev-parse --show-toplevel)

V=$(./scripts/greezly/find_out_grsecurity_version.pl |
	sed 's/-/ /g' | sed 's/\(^grsecurity \|\.patch$\)//g')
./scripts/greezly/fetch_n_apply_grsecurity_patch.sh $V
