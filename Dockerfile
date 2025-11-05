FROM gitea/act_runner:0.2.13

RUN apk add --no-cache curl

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set entrypoint to run the test + daemon
ENTRYPOINT ["/entrypoint.sh"]