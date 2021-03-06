#!/bin/bash

# Copyright (C) 2015, Moule Corp <greezly@moulecorp.org>

gv=$1
kv=$2
timestamp=$3

clean() {
	rm -f ../grsecurity-$gv-$kv-$timestamp.patch
	rm -f ../grsecurity-$gv-$kv-$timestamp.patch.sig
}

make_commit_message() {
	git log --pretty=format:"%b" --grep="Apply grsecurity patch" greezly |
		sed '/Signed-off-by: Moule Corp <greezly@moulecorp.org>/d' |
		sed -e :a -e '/./,$!d;/^\n*$/{$d;N;};/\n$/ba' >> last_changelog

	if [ ! -f ../changelog-stable2.txt ]; then
		wget https://grsecurity.net/changelog-stable2.txt -P .. ||
			(echo "Error while downloading grsecurity changelog" && exit 1)
	fi

	echo -e "Apply grsecurity patch $timestamp\n" > commit_message
	diff -U $(wc -l < last_changelog) last_changelog ../changelog-stable2.txt |
		grep -v '^+++\|^---' | grep '^+' | sed 's/^+//g' >> commit_message

	rm -f ../changelog-stable2.txt last_changelog
}

commit() {
	git add -A
	make_commit_message
	git commit -s -F commit_message
	rm -f commit_message
}

cd $(git rev-parse --show-toplevel)

if [ $(git --no-pager log --pretty=tformat:"%h" --grep="Apply grsecurity patch $timestamp" greezly | wc -l) -ge 1 ]; then
	echo "Abort: grsecurity patch $timestamp already applied."
	exit 0
fi

git fetch stable

if [ ! -f ../grsecurity-$gv-$kv-$timestamp.patch ]; then
	wget https://grsecurity.net/stable/grsecurity-$gv-$kv-$timestamp.patch -P .. ||
		(echo "Error while downloading the patch" && exit -1)
	wget https://grsecurity.net/stable/grsecurity-$gv-$kv-$timestamp.patch.sig -P .. ||
		(echo "Error while downloading the signature" && exit -1)

	gpg --verify ../grsecurity-$gv-$kv-$timestamp.patch.sig ||
		(echo "Wrong signature" && exit -1)
fi

git show-branch v${kv}
if [ $? -ne 0 ]; then
	echo "Counld not find local v${kv} branch"
	exit -1
fi

git checkout greezly
from=$(git rev-parse HEAD)
base=v$(make kernelversion)

ref_tag=$(git rev-parse v${kv}~0)
if [ $(git branch greezly --contains $ref_tag | wc -l) -ge 1 ]; then
	git checkout v$kv
	git apply ../grsecurity-$gv-$kv-$timestamp.patch
	git add -A
	git diff greezly --name-only | grep -v '^scripts/greezly\|greezly_defconfig$' | xargs git diff greezly -- > tmpPatch.diff
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

./scripts/greezly/keep_ours.sh $base $from greezly
git commit -s --amend --no-edit

clean
exit 0
