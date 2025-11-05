FROM gitea/act_runner:0.2.13

# Install Go/git for workflows (your Go build stage)
RUN apk add --no-cache go git

# Download Kaniko executor binary (daemonless builder)
RUN wget -O /usr/local/bin/executor https://github.com/GoogleContainerTools/kaniko/releases/download/v1.23.2/executor-linux-amd64 && \
    chmod +x /usr/local/bin/executor

# Create persistent data dir
RUN mkdir -p /data

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set working dir for .runner file
WORKDIR /data

ENTRYPOINT ["/entrypoint.sh"]