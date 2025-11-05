FROM gitea/act_runner:0.2.13

# Install Podman for daemonless Docker-compatible builds
RUN apk add --no-cache podman

# Go/git for workflows (Go mod/build)
RUN apk add --no-cache node

# Create persistent data dir
RUN mkdir -p /data

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set working dir for .runner file
WORKDIR /data

ENTRYPOINT ["/entrypoint.sh"]