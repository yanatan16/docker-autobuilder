#!/usr/bin/env bash

# First we docker login with the arguments given to this script
docker -H "unix:///host/var/run/docker.sock" login \
  --email "${DOCKER_EMAIL}" \
  --password "${DOCKER_PASSWORD}" \
  --username "${DOCKER_USERNAME}" \
  "${DOCKER_INDEX:-https://index.docker.io/v1/}"

# Start sockproc
/opt/sockproc/sockproc /tmp/shell.sock
chmod a+rwx /tmp/shell.sock

# now we startup nginx
nginx -p /app/ -c conf/nginx.conf &

# tail the build logs
touch /var/log/dockerbuild.log
tail -f /var/log/dockerbuild.log