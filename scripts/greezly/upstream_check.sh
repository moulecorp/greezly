#!/bin/bash

gv=$1
kv=$2
timestamp=$3

wget https://grsecurity.net/stable/grsecurity-$gv-$kv-$timestamp.patch -P .. &> /dev/null ||
	(echo "Error while downloading the patch" && exit -1)
wget https://grsecurity.net/stable/grsecurity-$gv-$kv-$timestamp.patch.sig -P .. &> /dev/null ||
	(echo "Error while downloading the signature" && exit -1)
gpg --verify ../grsecurity-$gv-$kv-$timestamp.patch.sig &> /dev/null ||
	(echo "Wrong signature" && exit -1)

sed -r '/index [a-z0-9]{7,}\.\.[a-z0-9]{7,}*/d' ../grsecurity-$gv-$kv-$timestamp.patch > grsec.diff
rm -f ../grsecurity-$gv-$kv-$timestamp.patch
rm -f ../grsecurity-$gv-$kv-$timestamp.patch.sig

git checkout -b tmp greezly &> /dev/null

git log --format="%H %s" --author=moulecorp.org --author=n0.pe Makefile arch/x86/configs/ scripts/greezly/ |
	grep -Ev "Merge branch|Apply grsecurity" | cut -d' ' -f1 |
	xargs -n1 git revert --no-commit

git -c 'core.abbrev=7' diff --patience v$kv |
	sed -r '/index [a-z0-9]{7,}\.\.[a-z0-9]{7,}*/d' > greezly.diff

git reset --hard &> /dev/null
git checkout greezly &> /dev/null
git branch -D tmp &> /dev/null

diff -q greezly.diff grsec.diff &> /dev/null
if [ $? -eq 0 ]; then
	echo "Current version of Greezly matches the upstream Grsecurity patch."
	ret=0
else
	echo "Current version of Greezly DOES NOT match the upstream Grsecurity patch!"
	ret=-1
fi

rm -f greezly.diff grsec.diff
exit $ret
