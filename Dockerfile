FROM jenkins/inbound-agent:latest

# Install dependencies
USER root
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common sshpass lsb-release

# Add Docker official GPG key and repository
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
    echo "deb [arch=amd64] https://download.docker.com/linux/debian bookworm stable" > /etc/apt/sources.list.d/docker.list

# Install Docker CLI and Docker Daemon
RUN apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io zip

# Allow Jenkins to use Docker without root privileges
RUN usermod -aG docker jenkins

# Install Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Enable Docker-in-Docker (DinD)
RUN mkdir -p /var/lib/docker
VOLUME /var/lib/docker

# Start the Docker daemon properly
CMD ["dockerd", "--host=unix:///var/run/docker.sock"]
