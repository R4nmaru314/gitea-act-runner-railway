#!/bin/sh

# Test connectivity to Gitea API (uses env var)
echo "Testing connectivity to ${GITEA_INSTANCE_URL}..."
if curl -f -s --max-time 10 "${GITEA_INSTANCE_URL}/api/v1/version" > /dev/null 2>&1; then
  echo "✓ Connectivity OK! Starting runner..."
else
  echo "✗ Connectivity FAILED! Check URL, firewall, or certs. Exiting to prevent loop."
  exit 1
fi

# Optional: Log env vars for debug (remove in prod)
echo "Runner config: NAME=${GITEA_RUNNER_NAME}, LABELS=${GITEA_RUNNER_LABELS}, EPHEMERAL=${GITEA_RUNNER_EPHEMERAL:-0}"

# Start the actual runner daemon
exec /usr/local/bin/act_runner daemon