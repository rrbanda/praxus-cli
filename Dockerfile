FROM registry.access.redhat.com/ubi9/ubi

USER 0
WORKDIR /home/devuser

RUN dnf install -y --allowerasing \
    bash \
    git \
    wget \
    unzip \
    curl \
    jq \
    vim \
    python3 \
    python3-pip \
    shadow-utils \
    which \
    && dnf clean all

RUN useradd -ms /bin/bash devuser

# Install ttyd (web terminal)
RUN wget -O /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.3/ttyd.x86_64 \
    && chmod +x /usr/local/bin/ttyd

USER devuser
WORKDIR /home/devuser

EXPOSE 7681
CMD ["ttyd", "-p", "7681", "bash"]
