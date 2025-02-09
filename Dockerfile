FROM jenkins/inbound-agent:latest

# Install dependencies
USER root
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common

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

# Install SDKMAN!
RUN curl -s "https://get.sdkman.io" | bash && \
    echo "source /root/.sdkman/bin/sdkman-init.sh" >> /root/.bashrc

# Ensure SDKMAN! works for Jenkins user
USER jenkins
RUN bash -c "curl -s \"https://get.sdkman.io\" | bash" && \
    echo "source /home/jenkins/.sdkman/bin/sdkman-init.sh" >> /home/jenkins/.bashrc

USER root

# Enable Docker-in-Docker (DinD)
RUN mkdir -p /var/lib/docker
VOLUME /var/lib/docker

# Start the Docker daemon properly
CMD ["dockerd", "--host=unix:///var/run/docker.sock"]
