#!/bin/sh

## fix OpenShift random UID display correct username
if [[ $UID -ge 10000 ]]; then
    GID=$(id -g)
    sed -e "s/^mattermost:x:[^:]*:[^:]*:/mattermost:x:$UID:$GID:/" /etc/passwd > /tmp/passwd
    cat /tmp/passwd > /etc/passwd
    rm /tmp/passwd
fi

## startup process
if [ "${1:0:1}" = '-' ]; then
    set -- mattermost "$@"
fi

exec "$@"
