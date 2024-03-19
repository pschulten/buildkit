# syntax = docker/dockerfile:1.7

FROM moby/buildkit:master
COPY --link --from=linuxkit/containerd:v1.0.0 /usr/bin/containerd /usr/bin/ctr /usr/bin/containerd-shim /usr/bin/containerd-shim-runc-v2 /usr/bin/

RUN  nohup containerd > /c.out 2> /c.err < /dev/null &


