#!/bin/bash

cd $(git rev-parse --show-toplevel)

V=$(./scripts/greezly/find_out_grsecurity_version.pl)
V=$(echo $V | sed 's/-/ /g' | sed 's/\(^grsecurity \|\.patch$\)//g')

./scripts/greezly/upstream_check.sh $V
