FROM docker.io/alpine:3.24.2 AS BUILD

ARG KUBECTL_VERSION
ARG TARGETOS
ARG TARGETARCH

RUN apk add --no-cache curl
RUN curl -LO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/${TARGETOS}/${TARGETARCH}/kubectl"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

FROM scratch

COPY --from=BUILD /usr/local/bin/kubectl /usr/local/bin/kubectl

ENTRYPOINT ["kubectl"]