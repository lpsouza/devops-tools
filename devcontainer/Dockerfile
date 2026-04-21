FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    ANSIBLE_PYTHON_INTERPRETER=auto_silent

# Install Ansible (git is usually pre-installed in this base image)
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    ansible && \
    apt-get clean

# Install Ansible collections separately
RUN --mount=type=cache,target=/root/.ansible/cp \
    ansible-galaxy collection install amazon.aws

# Clone and run playbooks
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    cd /tmp && \
    git clone --depth 1 https://github.com/lpsouza/linux-installer.git && \
    cd linux-installer && \
    bash generate-inventory.sh && \
    ansible-playbook -c local \
    playbooks/ubuntu/initial.yaml \
    playbooks/ubuntu/devops-tools.yaml && \
    ansible-playbook -c local \
    playbooks/ubuntu/cli.yaml --tags onepassword_cli && \
    cd .. && \
    rm -rf linux-installer && \
    rm -rf /root/.cache/ansible

