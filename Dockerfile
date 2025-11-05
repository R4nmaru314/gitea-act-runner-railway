FROM gitea/act_runner:0.2.13

RUN apk add --no-cache nodejs docker-cli

# Install Skaffold (CI/CD orchestrator)
RUN curl -Lo /tmp/install-skaffold.sh https://raw.githubusercontent.com/GoogleContainerTools/skaffold/main/install.sh && \
    sh /tmp/install-skaffold.sh --platform linux --version v2.15.0 && \
    mv /usr/local/bin/skaffold /usr/local/bin/skaffold && \
    rm /tmp/install-skaffold.sh

RUN wget -O /usr/local/bin/ko https://github.com/google/ko/releases/download/v0.17.1/ko-linux-amd64 && \
    chmod +x /usr/local/bin/ko

RUN mkdir -p /data

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /data

ENTRYPOINT ["/entrypoint.sh"]