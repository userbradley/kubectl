# Kubectl image

This repo contains CI and Dockerfile to build _literally_ just an image that contains `kubectl` binary

There's nothing fancy about it

This repo is pretty much handsoff in the sense that Renovate manages the dependencies and just auto-merges the `kubernetes/kubernete` package
so there's no work from me

## Why I made this

Because I sometimes need to run `kubectl` from within the cluster and the off the shelf kubectl images are massive and include
things like `helm` and other tools I do not care for.

The only image that's smaller (somehow) is the `bitnami/kubectl`, but they do not keep up to date with latest version

```
➜ podman image ls
REPOSITORY                   TAG         IMAGE ID      CREATED         SIZE
ghcr.io/userbradley/kubectl  1.37.0      6f4a1744624a  23 minutes ago  57.9 MB
docker.io/bitnami/kubectl    latest      1f35225e3fc7  4 days ago      216 MB
docker.io/alpine/kubectl     latest      fe0869ab32d3  5 days ago      72.4 MB
docker.io/rancher/kubectl    v1.35.6     d87edcf2f7c7  3 months ago    55.3 MB
```

## Using this

```shell
podman pull ghcr.io/userbradley/kubectl:1.37.0
```

podman run -it -v ~/.kube/config:/.kube/config ghcr.io/userbradley/kubectl:1.37.0 get pods

## Available tags

The image `ghcr.io/userbradley/kubectl` follows Kubernetes releases, so any version of kubernetes will be supported

## Example deployment to roll pods

```yaml
kind: ServiceAccount
apiVersion: v1
metadata:
  name: zigbee2mqtt-roller
  labels:
    app.kubernetes.io/name: zigbee2mqtt
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: zigbee2mqtt-roller
rules:
  - apiGroups:
      - ""
    resources:
      - pods
    verbs:
      - get
      - list
      - delete
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: zigbee2mqtt-roller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: zigbee2mqtt-roller
subjects:
  - kind: ServiceAccount
    name: zigbee2mqtt-roller
---
apiVersion: batch/v1
kind: CronJob
metadata:
  name: zigbee2mqtt-roller
spec:
  concurrencyPolicy: Forbid
  schedule: "0 0 * * *"
  jobTemplate:
    spec:
      backoffLimit: 2
      activeDeadlineSeconds: 20
      ttlSecondsAfterFinished: 10
      template:
        spec:
          serviceAccountName: zigbee2mqtt-roller
          restartPolicy: Never
          containers:
            - name: kubectl
              image: ghcr.io/userbradley/kubectl:latest # Do not pin to latest, this is an example!
              command:
                - 'kubectl'
                - 'delete'
                - 'pod'
                - '-l app=zigbee2mqtt'

```
