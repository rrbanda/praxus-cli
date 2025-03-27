FROM registry.access.redhat.com/ubi9/ubi

# Switch to root
USER 0
WORKDIR /home/devuser

# Install required tools
RUN sed -i 's/enabled=0/enabled=1/' /etc/yum.repos.d/ubi.repo || true && \
    dnf install -y \
    git \
    bash \
    wget \
    unzip \
    gcc \
    make \
    podman \
    cmake \
    which \
    shadow-utils \
    && dnf clean all

# Create non-root user
RUN useradd -ms /bin/bash devuser

# Create ~/.config and fix ownership BEFORE switching to devuser
RUN mkdir -p /home/devuser/.config && chown -R devuser:devuser /home/devuser

# Download ttyd
RUN wget -O /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /usr/local/bin/ttyd

# Now switch to non-root user
USER devuser
WORKDIR /home/devuser

EXPOSE 7681

CMD ["ttyd", "-p", "7681", "bash"]
