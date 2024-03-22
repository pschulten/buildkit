# syntax = docker/dockerfile:1.7
FROM debian:unstable

RUN apt-get update && apt-get install -y \
    git containerd supervisor procps \
    && rm -rf /var/lib/apt/lists/*

COPY --link etc /etc
COPY --link --from=moby/buildkit:latest /usr/bin/buildkitd /usr/bin/buildkitd
COPY --link --from=moby/buildkit:latest /usr/bin/buildctl /usr/bin/buildctl

ENTRYPOINT ["/usr/bin/supervisord"]
