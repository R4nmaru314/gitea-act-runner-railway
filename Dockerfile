FROM gitea/act_runner:0.2.13

RUN apk add --no-cache nodejs docker-cli curl

# Install Skaffold (CI/CD orchestrator)
# Install Skaffold binary (CI/CD orchestrator)
RUN curl -Lo /usr/local/bin/skaffold https://storage.googleapis.com/skaffold/releases/v2.15.0/skaffold-linux-amd64 && \
    chmod +x /usr/local/bin/skaffold

# Install ko (daemonless Go builder)
RUN wget -O /usr/local/bin/ko https://github.com/google/ko/releases/download/v0.17.1/ko-linux-amd64 && \
    chmod +x /usr/local/bin/ko

RUN mkdir -p /data

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /data

ENTRYPOINT ["/entrypoint.sh"]