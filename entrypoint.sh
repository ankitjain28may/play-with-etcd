#!/bin/sh

ARG="new"

if [ -z "$1" ]; then
    ARG=$1
fi

IP=`hostname -i | awk '{print $1}'`

new() {
    /usr/local/bin/etcd --name=${NAME} \
    --data-dir=/var/etcd/ \
    --advertise-client-urls=${ADVERTISE_PEER_URLS} \
    --initial-cluster=${INITIAL_CLUSTER} \
    --initial-advertise-peer-urls=${INITIAL_ADVERTISE_PEER_URLS} \
    --listen-client-urls=http://`hostname -i`:2379 \
    --listen-peer-urls=http://`hostname -i`:2380 \
    --auto-compaction-retention 168
}



existing() {
    /usr/local/bin/etcd --name=${NAME} \
    --data-dir=/var/etcd/ \
    --advertise-client-urls=${ADVERTISE_PEER_URLS} \
    --initial-cluster=${INITIAL_CLUSTER} \
    --initial-advertise-peer-urls=${INITIAL_ADVERTISE_PEER_URLS} \
    --listen-client-urls=http://`hostname -i`:2379 \
    --listen-peer-urls=http://`hostname -i`:2380 \
    --auto-compaction-retention 168 \
    --initial-cluster-state=existing
}

if [[ "$ARG" = "existing" ]]; then
    existing
else
    new
fi