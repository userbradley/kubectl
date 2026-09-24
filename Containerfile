FROM scratch
COPY kubectl /usr/local/bin/kubectl
ENTRYPOINT ["/usr/local/bin/kubectl"]
