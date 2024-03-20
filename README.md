# buildkit

# rootless fails
```console
docker buildx build .
...
WARNING: No output specified with remote driver. Build result will only remain in the build cache. To push result image into registry use --push or to load image into docker use --load
Dockerfile:3
--------------------
   1 |     #FROM scratch
   2 |     FROM alpine
   3 | >>> COPY deploy.yaml /
   4 |     
--------------------
ERROR: failed to solve: invalid argument
```
