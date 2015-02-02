#!/usr/bin/env bash

FULLREPO=$1
REPO=${FULLREPO%%#*} # org/repo#branch
BRANCH=${FULLREPO##*#}
IMAGE=$2
TMP=$(mktemp -d)

function runf() {
  $@ 2>&1 | tee -a /var/log/dockerbuild.log
}

echo "Building $FULLREPO and tagging as $IMAGE." | tee -a /var/log/dockerbuild.log

cd $TMP
runf git clone --recursive -b $BRANCH git@github.com:$REPO builddir
runf sudo docker -H "unix:///host/var/run/docker.sock" \
  build -t $IMAGE --pull builddir
runf sudo docker -H "unix:///host/var/run/docker.sock" \
  push $IMAGE 2>&1
cd -
rm -rf $TMP

echo "Successfully pushed $IMAGE built from $FULLREPO" | tee -a /var/log/dockerbuild.log