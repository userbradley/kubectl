FROM scratch
ARG TARGETARCH
COPY bin/${TARGETARCH}/kubectl /usr/local/bin/kubectl
ENTRYPOINT ["/usr/local/bin/kubectl"]
