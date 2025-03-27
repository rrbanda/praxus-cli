# Use full UBI 9 base (not minimal)
FROM registry.access.redhat.com/ubi9/ubi

# Switch to root to install packages
USER 0

# Install CLI tools + dependencies
RUN dnf install -y \
    bash \
    git \
    curl \
    unzip \
    wget \
    make \
    gcc \
    cmake \
    which \
    shadow-utils \
    && dnf clean all

# Create non-root user (OpenShift compatible)
RUN useradd -ms /bin/bash devuser

# Install ttyd (precompiled binary)
RUN curl -L -o /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /usr/local/bin/ttyd

USER devuser
WORKDIR /home/devuser

EXPOSE 7681

# Start web terminal with bash
CMD ["ttyd", "-p", "7681", "bash"]
