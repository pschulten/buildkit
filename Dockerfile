# syntax = docker/dockerfile:1.7

#FROM moby/buildkit:master
#COPY --link --from=linuxkit/containerd:v1.0.0 /usr/bin/containerd /usr/bin/ctr /usr/bin/containerd-shim /usr/bin/containerd-shim-runc-v2 /usr/bin/
#
#ENTRYPOINT ["nohup", "containerd", "1>/dev/stdout", "2>/dev/stderr", "&",  "buildkitd"]


FROM moby/buildkit:master-rootless

USER 0
RUN mkdir /var/lib/containerd && chmod 0777 /var/lib/containerd && \
    mkdir /run/containerd && chmod 0777 /run/containerd

USER 1000
COPY --link --from=linuxkit/containerd:v1.0.0 /usr/bin/containerd /usr/bin/ctr /usr/bin/containerd-shim /usr/bin/containerd-shim-runc-v2 /usr/bin/

ENTRYPOINT ["nohup", "rootlesskit", "containerd", "1>/dev/stdout", "2>/dev/stderr", "&", "rootlesskit", "buildkitd"]
