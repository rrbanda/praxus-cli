
# 🧱 Base Image: Red Hat UBI 9
FROM registry.access.redhat.com/ubi9/ubi

# 🛠 Switch to root to install packages
USER 0
WORKDIR /home/devuser

# 🔧 Enable dev tools + Install CLI utilities + Podman
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

# 👤 Create non-root user and ensure /home/devuser/.config exists for podman
RUN useradd -ms /bin/bash devuser && \
    mkdir -p /home/devuser/.config && \
    chown -R devuser:devuser /home/devuser

# 🌐 Download and install ttyd (Web Terminal)
RUN wget -O /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /usr/local/bin/ttyd

# 🔒 Switch to non-root user (OpenShift-compatible)
USER devuser
WORKDIR /home/devuser

# 🌍 Expose the web terminal port
EXPOSE 7681

# 🚀 Start ttyd with bash
CMD ["ttyd", "-p", "7681", "bash"]
