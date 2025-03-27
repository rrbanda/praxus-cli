FROM registry.access.redhat.com/ubi9/ubi

USER 0

RUN dnf install -y \
    bash \
    git \
    curl \
    unzip \
    && dnf clean all

# Add additional tools here (kubectl, python3, node, etc)

USER 1001
WORKDIR /workspace
CMD ["/bin/bash"]
