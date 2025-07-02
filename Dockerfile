FROM ubuntu:24.04

# Install devops tools
RUN apt-get update && \
    apt-get install -y ansible && \
    ansible-galaxy collection install amazon.aws && \
    cd /tmp && \
    git clone https://github.com/lpsouza/linux-installer.git && \
    cd linux-installer && \
    bash generate-inventory.sh && \
    ansible-playbook playbooks/devops-tools.yml && \
    cd .. && \
    rm -rf linux-installer && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure VS Code compatibility (devcontainer)
RUN useradd -m -s /bin/bash vscode && \
    echo "vscode ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
