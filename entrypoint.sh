#!/bin/sh

echo "=== DEBUG: Environment Variables ==="
# Check each critical var
if [ -z "$GITEA_INSTANCE_URL" ]; then
  echo "❌ CRITICAL: GITEA_INSTANCE_URL is empty! Set it to https://your-gitea.com"
else
  echo "✓ GITEA_INSTANCE_URL: ${GITEA_INSTANCE_URL}"
fi

if [ -z "$GITEA_RUNNER_REGISTRATION_TOKEN" ]; then
  echo "❌ CRITICAL: GITEA_RUNNER_REGISTRATION_TOKEN is empty! Generate in Gitea."
else
  echo "✓ GITEA_RUNNER_REGISTRATION_TOKEN: SET (length: ${#GITEA_RUNNER_REGISTRATION_TOKEN})"
fi

echo "GITEA_RUNNER_NAME: ${GITEA_RUNNER_NAME:-unset}"
echo "GITEA_RUNNER_LABELS: ${GITEA_RUNNER_LABELS:-unset}"
echo "GITEA_RUNNER_EPHEMERAL: ${GITEA_RUNNER_EPHEMERAL:-0}"

# List all GITEA vars for completeness
echo "All GITEA vars:"
env | grep '^GITEA_' || echo "No GITEA vars found!"
echo "=== END DEBUG ==="

# Connectivity test (skip if URL empty, non-fatal)
if [ -n "$GITEA_INSTANCE_URL" ]; then
  echo "Testing connectivity to ${GITEA_INSTANCE_URL}..."
  if curl -f -s --max-time 10 --insecure "${GITEA_INSTANCE_URL}/api/v1/version" > /dev/null 2>&1; then
    echo "✓ Connectivity OK!"
  else
    echo "⚠ Connectivity issue (proceeding; check firewall/certs)"
  fi
else
  echo "⚠ Skipping connectivity test (URL empty)"
fi

# Start runner (will register if token/URL present)
echo "Starting act_runner daemon in /data..."
exec /usr/local/bin/act_runner daemon