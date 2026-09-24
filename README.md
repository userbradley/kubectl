# Kubectl image

This repo contains CI and Dockerfile to build _literally_ just an image that contains `kubectl` binary

There's nothing fancy about it

## Build the image locally

The below will build the image locally, and it will not push it.

### Podman

```shell
podman build --platform=linux/arm64 --build-arg KUBECTL_VERSION=1.31.0 -t kubectl:<tag> .
podman build --platform=linux/amd64 --build-arg KUBECTL_VERSION=1.31.0 -t kubectl:<tag> .
```

## Verify the image works

```shell
podman run -it -v ~/.kube/config:/.kube/config localhost/kubectl:<tag> get pods
NAME                        READY   STATUS    RESTARTS   AGE
homepage-69b4845dbd-6j6hn   1/1     Running   0          3d16h
```
