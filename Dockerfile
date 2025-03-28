FROM registry.access.redhat.com/ubi9/ubi

USER 0
WORKDIR /home/devuser

# Create non-root user early
RUN useradd -m devuser

# Add essential tools one by one to identify issues
RUN dnf install -y \
    bash \
    git \
    wget \
    unzip \
    curl \
    make \
    gcc \
    cmake \
    which \
    shadow-utils \
    && dnf clean all

# Separate Podman install (known to require additional setup)
RUN dnf install -y podman fuse-overlayfs slirp4netns container-selinux && dnf clean all

# ✅ Avoid podman crash due to missing config directory
RUN mkdir -p /home/devuser/.config && chown -R devuser:devuser /home/devuser

# Install ttyd for web-based CLI access
RUN wget -O /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /usr/local/bin/ttyd

USER devuser
WORKDIR /home/devuser

EXPOSE 7681

CMD ["ttyd", "-p", "7681", "bash"]
