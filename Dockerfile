FROM ubuntu:18.04

RUN apt-get update -y && \
    apt-get install curl netcat make -y

ARG ETCD_VER=v3.4.7
ARG GOOGLE_URL=https://storage.googleapis.com/etcd
ARG GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
ARG DOWNLOAD_URL=${GOOGLE_URL}
WORKDIR /app

RUN mkdir -p /tmp/etcd-download-test && \
    curl -L $DOWNLOAD_URL/$ETCD_VER/etcd-$ETCD_VER-linux-amd64.tar.gz -o /tmp/etcd-$ETCD_VER-linux-amd64.tar.gz && \
    tar xzvf /tmp/etcd-$ETCD_VER-linux-amd64.tar.gz -C /tmp/etcd-download-test --strip-components=1 && \
    rm -f /tmp/etcd-$ETCD_VER-linux-amd64.tar.gz

RUN mv /tmp/etcd-download-test/etcd /usr/local/bin/etcd && \
    mv /tmp/etcd-download-test/etcdctl /usr/local/bin/etcdctl

CMD [ "/bin/sh" ]