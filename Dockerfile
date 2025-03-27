FROM registry.access.redhat.com/ubi9/ubi

USER 0
WORKDIR /home/devuser

# 🔧 Enable Repos for dev tools (especially for make, gcc, etc.)
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

# Create user for non-root runtime (OpenShift compatibility)
RUN useradd -ms /bin/bash devuser

# Download and install ttyd (web terminal)
RUN wget -O /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x /usr/local/bin/ttyd

USER devuser
WORKDIR /home/devuser

EXPOSE 7681

CMD ["ttyd", "-p", "7681", "bash"]
