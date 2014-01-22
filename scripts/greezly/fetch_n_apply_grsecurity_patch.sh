#!/bin/bash

gv=$1
kv=$2
timestamp=$3

clean() {
	rm ../grsecurity-$gv-$kv-$timestamp.patch
	rm ../grsecurity-$gv-$kv-$timestamp.patch.sig
}

commit() {
	git add -A
	git commit -m"Apply grsecurity patch $timestamp"
}

cd $(git rev-parse --show-toplevel)

wget https://grsecurity.net/stable/grsecurity-$gv-$kv-$timestamp.patch -P .. ||
	(echo "Error while downloading the patch" && exit -1)
wget https://grsecurity.net/stable/grsecurity-$gv-$kv-$timestamp.patch.sig -P .. ||
	(echo "Error while downloading the signature" && exit -1)

gpg --verify ../grsecurity-$gv-$kv-$timestamp.patch.sig ||
	(echo "Wrong signature" && exit -1)

git show-branch v${kv}
if [ $? -ne 0 ]; then
	echo "Counld not find local v${kv} branch"
	exit -1
fi

ref_tag=$(git rev-parse v${kv}~0)
if [ $(git branch greezly --contains $ref_tag) -ge 0 ]; then
	git checkout v$kv
	git apply ../grsecurity-$gv-$kv-$timestamp.patch
	git add -A
	git diff greezly --name-only | grep -v '^scripts/greezly' | xargs git diff greezly -- > tmpPatch.diff
	git reset --hard

	git checkout greezly
	git apply tmpPatch.diff
	rm tmpPatch.diff
	commit
else
	git show-branch v$kv
	if [ $? -eq 0 ]; then
		git checkout -b linux-$kv-for-greezly v$kv
		git apply ../grsecurity-$gv-$kv-$timestamp.patch
		commit

		git checkout greezly
		./scripts/greezly/merge_theirs.sh greezly linux-$kv-for-greezly
		git branch -D linux-$kv-for-greezly
	else
		echo "No branch found to apply the grsecurity patch"
		clean
		exit -1
	fi
fi

clean
exit 0
