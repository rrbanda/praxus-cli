# Containerfile

# ✅ Base image with package manager and system tools
FROM registry.access.redhat.com/ubi9/ubi

# Use root to install dependencies
USER 0

# Create non-root user
RUN useradd -m devuser

# Install CLI tools including podman and dependencies
RUN dnf install -y \
    bash \
    git \
    wget \
    unzip \
    curl \
    make \
    gcc \
    cmake \
    podman \
    shadow-utils \
    which \
    && dnf clean all

# ✅ Create config directory and fix ownership for podman to avoid .config crash
RUN mkdir -p /home/devuser/.config && \
    chown -R devuser:devuser /home/devuser

# Download and install ttyd (web terminal server)
RUN wget -O /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /usr/local/bin/ttyd

# Drop to the non-root user
USER devuser
WORKDIR /home/devuser

# Expose port ttyd will use
EXPOSE 7681

# Run web terminal with bash
CMD ["ttyd", "-p", "7681", "bash"]
