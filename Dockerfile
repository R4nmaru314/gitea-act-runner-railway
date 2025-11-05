FROM gitea/act_runner:0.2.13

RUN apk add --no-cache nodejs docker-cli curl

# Install Skaffold (CI/CD orchestrator)
# Install Skaffold binary (CI/CD orchestrator)
RUN curl -Lo /usr/local/bin/skaffold https://storage.googleapis.com/skaffold/releases/v2.15.0/skaffold-linux-amd64 && \
    chmod +x /usr/local/bin/skaffold

# Install ko (daemonless Go builder)
RUN wget -O /tmp/ko.tar.gz https://github.com/ko-build/ko/releases/download/v0.18.0/ko_0.18.0_Linux_x86_64.tar.gz && \
    tar -xzf /tmp/ko.tar.gz -C /tmp && \
    mv /tmp/ko /usr/local/bin/ko && \
    chmod +x /usr/local/bin/ko && \
    rm /tmp/ko.tar.gz

RUN mkdir -p /data

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /data

ENTRYPOINT ["/entrypoint.sh"]