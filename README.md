# buildkit

# current problem
## run
```shell
docker build -t bk . && \
  docker run --rm --privileged -p 1234:1234 --name buildkit bk
```

## failure 1
```console
~ ❯ docker exec -it buildkit bash
root@e9d8364f96dc:/# cat <<EOF > /tmp/Dockerfile
FROM alpine
RUN echo hello
EOF

buildctl build \
  --progress=plain --frontend=dockerfile.v0 --local context=/tmp --local dockerfile=/tmp \
  --output type=image,name=test,push=false
#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 127B done
#1 DONE 0.0s

#2 [internal] load metadata for docker.io/library/alpine:latest
#2 DONE 1.3s

#3 [internal] load .dockerignore
#3 transferring context: 2B done
#3 DONE 0.0s

#4 [1/2] FROM docker.io/library/alpine:latest@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b
#4 resolve docker.io/library/alpine:latest@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b 0.0s done
#4 sha256:bca4290a96390d7a6fc6f2f9929370d06f8dfcacba591c76e3d5c5044e7f420c 0B / 3.35MB 0.2s
#4 sha256:bca4290a96390d7a6fc6f2f9929370d06f8dfcacba591c76e3d5c5044e7f420c 3.35MB / 3.35MB 0.3s done
#4 extracting sha256:bca4290a96390d7a6fc6f2f9929370d06f8dfcacba591c76e3d5c5044e7f420c
#4 extracting sha256:bca4290a96390d7a6fc6f2f9929370d06f8dfcacba591c76e3d5c5044e7f420c 0.2s done
#4 DONE 0.4s

#5 [2/2] RUN echo hello
#5 ERROR: process "/bin/sh -c echo hello" did not complete successfully: invalid argument
------
 > [2/2] RUN echo hello:
------
Dockerfile:2
--------------------
   1 |     FROM alpine
   2 | >>> RUN echo hello
   3 |     
--------------------
error: failed to solve: process "/bin/sh -c echo hello" did not complete successfully: invalid argument
```

## failure 2
```console
~ ❯ docker exec -it buildkit bash
root@bf93299b7634:/# cat <<EOF > /tmp/Dockerfile
FROM alpine
COPY  Dockerfile /tmp
RUN echo
EOF

buildctl build \
  --progress=plain --frontend=dockerfile.v0 --local context=/tmp --local dockerfile=/tmp \
  --output type=image,name=test,push=false
#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 143B done
#1 DONE 0.0s

#2 [internal] load metadata for docker.io/library/alpine:latest
#2 DONE 1.3s

#3 [internal] load .dockerignore
#3 transferring context: 2B done
#3 DONE 0.0s

#4 [internal] load build context
#4 transferring context: 143B done
#4 DONE 0.0s

#5 [1/3] FROM docker.io/library/alpine:latest@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b
#5 resolve docker.io/library/alpine:latest@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b 0.0s done
#5 sha256:bca4290a96390d7a6fc6f2f9929370d06f8dfcacba591c76e3d5c5044e7f420c 0B / 3.35MB 0.2s
#5 sha256:bca4290a96390d7a6fc6f2f9929370d06f8dfcacba591c76e3d5c5044e7f420c 3.35MB / 3.35MB 0.3s done
#5 extracting sha256:bca4290a96390d7a6fc6f2f9929370d06f8dfcacba591c76e3d5c5044e7f420c
#5 extracting sha256:bca4290a96390d7a6fc6f2f9929370d06f8dfcacba591c76e3d5c5044e7f420c 0.2s done
#5 DONE 0.5s

#6 [2/3] COPY  Dockerfile /tmp
#6 ERROR: invalid argument
------
 > [2/3] COPY  Dockerfile /tmp:
------
Dockerfile:2
--------------------
   1 |     FROM alpine
   2 | >>> COPY  Dockerfile /tmp
   3 |     RUN echo
   4 |     
--------------------
error: failed to solve: invalid argument
root@bf93299b7634:/# cat <<EOF > /tmp/Dockerfile
FROM alpine
COPY  Dockerfile /tmp
RUN echo
EOF

buildctl build \
  --progress=plain --frontend=dockerfile.v0 --local context=/tmp --local dockerfile=/tmp \
  --output type=image,name=test,push=false
#1 [internal] load build definition from Dockerfile
#1 transferring dockerfile: 143B done
#1 DONE 0.0s

#2 [internal] load metadata for docker.io/library/alpine:latest
#2 DONE 0.7s

#3 [internal] load .dockerignore
#3 transferring context: 2B done
#3 DONE 0.0s

#4 [1/3] FROM docker.io/library/alpine:latest@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b
#4 resolve docker.io/library/alpine:latest@sha256:c5b1261d6d3e43071626931fc004f70149baeba2c8ec672bd4f27761f8e1ad6b 0.0s done
#4 CACHED

#5 [internal] load build context
#5 transferring context: 143B done
#5 DONE 0.0s

#6 [2/3] COPY  Dockerfile /tmp
#6 ERROR: invalid argument
------
 > [2/3] COPY  Dockerfile /tmp:
------
Dockerfile:2
--------------------
   1 |     FROM alpine
   2 | >>> COPY  Dockerfile /tmp
   3 |     RUN echo
   4 |     
--------------------
error: failed to solve: invalid argument
```
