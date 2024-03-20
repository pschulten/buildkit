# syntax = docker/dockerfile:1.7
FROM moby/buildkit:nightly-rootless

USER 0
RUN mkdir /var/lib/containerd && chmod 0777 /var/lib/containerd && \
    mkdir /run/containerd && chmod 0777 /run/containerd && \
    mkdir /etc/cni && chmod 0777 /etc/cni && \
    apk add --no-cache supervisor go

COPY --link --from=linuxkit/containerd:v1.0.0 /usr/bin/containerd /usr/bin/ctr /usr/bin/containerd-shim /usr/bin/containerd-shim-runc-v2 /usr/bin/
COPY --link etc /etc


RUN #wget -q -O - https://raw.githubusercontent.com/containerd/containerd/124456ef83f5984e597c4ab2b48b9074199c1aa0/script/setup/install-cni | sh

USER 1000
ENTRYPOINT ["/usr/bin/supervisord"]
