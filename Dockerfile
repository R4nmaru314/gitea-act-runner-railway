FROM gitea/act_runner:0.2.13

# Install curl for debugging
RUN apk add --no-cache curl bind-tools  # bind-tools adds nslookup/dig

# Force IPv4 preference in resolver (fixes Railway IPv6 default)
RUN echo 'precedence ::ffff:0:0/96 100' >> /etc/gai.conf

# Create persistent data dir
RUN mkdir -p /data

# Copy and make executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Set working dir for .runner file
WORKDIR /data

ENTRYPOINT ["/entrypoint.sh"]