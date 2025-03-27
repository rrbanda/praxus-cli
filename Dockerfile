# Use UBI or Debian/Alpine as base depending on your toolchain needs
FROM registry.access.redhat.com/ubi9/ubi-minimal

# Install CLI tools needed for your terminal (e.g., curl, git, bash, zsh, kubectl)
RUN microdnf install -y \
    bash \
    git \
    curl \
    unzip \
    && microdnf clean all

# Set up non-root user if needed (for security or OpenShift compatibility)
RUN useradd -ms /bin/bash devuser
USER devuser
WORKDIR /home/devuser

# Optional: Set shell and terminal startup
CMD [ "bash" ]
