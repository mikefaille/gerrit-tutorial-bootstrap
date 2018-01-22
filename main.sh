#!/usr/bin/env bash
set -xe

DEFAULT_PROJECT_NAME="test_project-"$(date +%s)
PROJECT_NAME=$DEFAULT_PROJECT_NAME

TEST_ACCOUNT=test-account7
TEST_ACCOUNT_EMAIL=test-account7@example.com

ssh -p29418 admin@127.0.0.1 gerrit create-project $PROJECT_NAME
# : ${PROJECT_NAME:-$DEFAULT_PROJECT_NAME}}

OUT=$(mktemp -d /tmp/boostrap-gerrit.XXXXXXXXXX) || { echo "Failed to create temp file"; exit 1; }

mkdir $OUT/$PROJECT_NAME

pushd $OUT/$PROJECT_NAME
git init
git config --global user.name "John Doe"
git config --global user.email $TEST_ACCOUNT_EMAIL

git remote add origin ssh://${TEST_ACCOUNT}@127.0.0.1:29418/${PROJECT_NAME}
gitdir=$(git rev-parse --git-dir); scp -p -P 29418 admin@127.0.0.1:hooks/commit-msg ${gitdir}/hooks/
# git push origin HEAD:refs/for/master
git status
touch mon_fichier1.txt
git add mon_fichier1.txt
git commit -m 'Voici mon commit de test'
HEAD_COMMIT_ID=$(git log --format="%H" -n 1)
CHANGE_ID=$(git show HEAD | sed -rn 's/Change-Id: ([a-zA-Z0-9]+)/\1/p')
echo "The change_id of the last commit is: ${CHANGE_ID}"
git push origin HEAD:refs/for/master

popd
ssh -p29418 admin@127.0.0.1 gerrit review $HEAD_COMMIT_ID --code-review +2

echo -- example 1
cat example1.pl | ssh -p29418 admin@127.0.0.1 gerrit test-submit rule $CHANGE_ID  -s

echo -- example 3
cat example3.pl | ssh -i test -p29418 ${TEST_ACCOUNT}@127.0.0.1 gerrit test-submit rule $CHANGE_ID  -s
