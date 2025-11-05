FROM gitea/act_runner:0.2.13

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

echo "Runner config: NAME=${GITEA_RUNNER_NAME}"

ENTRYPOINT ["/entrypoint.sh"]