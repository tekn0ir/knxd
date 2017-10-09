#!/bin/sh
set -xe

# Add user with external UID
# Either use the USER_ID if passed in at runtime or fallback
# Run container with docker run -it -e DOCKER_GID=`getent group docker | awk -F: '{printf "%d", $3}'` -e USER_ID=`id -u $USER` myimage

USER_ID=${USER_ID:-9001}
DOCKER_GID=${DOCKER_GID:-9002}
USER_NAME=$GOSU_NAME

exec /usr/local/bin/gosu $USER_ID:$DOCKER_GID "$@"
