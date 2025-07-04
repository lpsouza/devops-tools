FROM ubuntu:24.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install devops tools
RUN apt-get update && \
    apt-get install -y git ansible && \
    ansible-galaxy collection install amazon.aws && \
    cd /tmp && \
    git clone https://github.com/lpsouza/linux-installer.git && \
    cd linux-installer && \
    bash generate-inventory.sh && \
    ansible-playbook \
    playbooks/ubuntu/initial.yaml \
    playbooks/ubuntu/devops-tools.yaml && \
    cd .. && \
    rm -rf linux-installer && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure VS Code compatibility (devcontainer)
RUN useradd -m -s /bin/bash vscode && \
    echo "vscode ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
