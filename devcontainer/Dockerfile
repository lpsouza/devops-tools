FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Version arguments with default values
ARG TERRAFORM_VERSION=1.9.5
ARG OP_VERSION=2.30.0

# Install base packages and Ansible
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        git \
        jq \
        unzip \
        openssh-client \
        sshpass \
        gnupg \
        python3 \
        python3-pip \
        python3-boto3 \
        python3-botocore \
        python3-yaml \
        ansible && \
    rm -rf /var/lib/apt/lists/*

# Install Ansible collections globally so all users (including vscode) have access
RUN mkdir -p /usr/share/ansible/collections && \
    ansible-galaxy collection install amazon.aws -p /usr/share/ansible/collections

# Install Terraform (Multi-arch)
ARG TARGETARCH
RUN curl -fsSL "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip" -o /tmp/terraform.zip && \
    unzip -q /tmp/terraform.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/terraform && \
    rm -f /tmp/terraform.zip

# Install 1Password CLI (Multi-arch)
RUN curl -fsSL "https://cache.agilebits.com/dist/1P/op2/pkg/v${OP_VERSION}/op_linux_${TARGETARCH}_v${OP_VERSION}.zip" -o /tmp/op.zip && \
    unzip -q /tmp/op.zip -d /tmp/op_extracted && \
    mv /tmp/op_extracted/op /usr/local/bin/op && \
    chmod +x /usr/local/bin/op && \
    rm -rf /tmp/op*

# Install AWS CLI v2 (Multi-arch)
RUN case "${TARGETARCH}" in \
        "amd64") AWS_ARCH="x86_64" ;; \
        "arm64") AWS_ARCH="aarch64" ;; \
        *) echo "Unsupported architecture: ${TARGETARCH}" && exit 1 ;; \
    esac && \
    curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-${AWS_ARCH}.zip" -o /tmp/awscliv2.zip && \
    unzip -q /tmp/awscliv2.zip -d /tmp && \
    /tmp/aws/install && \
    rm -rf /tmp/aws /tmp/awscliv2.zip

