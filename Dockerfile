FROM mcr.microsoft.com/dotnet/core/sdk:3.1.302-bionic
RUN apt-get update && apt-get -y --no-install-recommends install unzip apt-transport-https ca-certificates curl software-properties-common jq \
    && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" \
    && add-apt-repository ppa:git-core/ppa \
    && apt-get update \
    && apt-get install --no-install-recommends docker-ce-cli git -y \
    && rm -rf /var/lib/apt/lists/* \
    && git --version
    
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

RUN echo "fs.file-max = 65535" >> /etc/sysctl.conf \
    && sysctl -p

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 16

# Replace shell with bash so we can source files
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install pre-reqs
RUN apt-get update
RUN apt-get -y install curl build-essential

# Install NVM
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.30.1/install.sh | bash

# Install NODE
RUN source ~/.nvm/nvm.sh; \
    nvm install 16.15.1; \
    nvm use --delete-prefix 16.15.1;

# Increase file read limits by appending to conf files
RUN echo "root soft     nproc          65535" >> /etc/security/limits.conf
RUN echo "root hard     nproc          65535" >> /etc/security/limits.conf
RUN echo "root soft     nofile         65535" >> /etc/security/limits.conf
RUN echo "root hard     nofile         65535" >> /etc/security/limits.conf

RUN echo "session required pam_limits.so" >> /etc/pam.d/common-session
