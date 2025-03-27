FROM registry.access.redhat.com/ubi9/ubi

USER 0

# Install CLI tools + ttyd
RUN dnf install -y \
    bash \
    git \
    curl \
    unzip \
    wget \
    make \
    gcc \
    cmake \
    && dnf clean all && \
    curl -LO https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 && \
    chmod +x ttyd.x86_64 && mv ttyd.x86_64 /usr/local/bin/ttyd

# Set up default user/workdir
RUN useradd -ms /bin/bash devuser
USER devuser
WORKDIR /home/devuser

# Launch bash in web terminal on port 7681
EXPOSE 7681
CMD ["ttyd", "-p", "7681", "/bin/bash"]
