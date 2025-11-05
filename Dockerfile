FROM gitea/act_runner:0.2.13

# Install curl for debugging
RUN apk add --no-cache curl

# Create persistent data dir
RUN mkdir -p /data

# Copy and make executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set working dir for .runner file
WORKDIR /data

ENTRYPOINT ["/entrypoint.sh"]