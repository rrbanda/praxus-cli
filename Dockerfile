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

# Download ttyd
RUN wget -O /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /usr/local/bin/ttyd

# Switch to devuser
USER devuser
WORKDIR /home/devuser

# ✅ Create .config folder AFTER switching to user
RUN mkdir -p /home/devuser/.config

EXPOSE 7681

CMD ["ttyd", "-p", "7681", "bash"]
