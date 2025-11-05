#!/bin/sh

echo "=== DEBUG: Environment Variables ==="
if [ -z "$GITEA_INSTANCE_URL" ]; then
  echo "❌ CRITICAL: GITEA_INSTANCE_URL empty!"
  exit 1
fi
echo "✓ GITEA_INSTANCE_URL: ${GITEA_INSTANCE_URL}"

if [ -z "$GITEA_RUNNER_REGISTRATION_TOKEN" ]; then
  echo "❌ CRITICAL: GITEA_RUNNER_REGISTRATION_TOKEN empty!"
  exit 1
else
  echo "✓ GITEA_RUNNER_REGISTRATION_TOKEN: SET (length: ${#GITEA_RUNNER_REGISTRATION_TOKEN})"
fi

echo "GITEA_RUNNER_NAME: ${GITEA_RUNNER_NAME:-unset}"
echo "GITEA_RUNNER_LABELS: ${GITEA_RUNNER_LABELS:-unset}"
echo "GITEA_RUNNER_EPHEMERAL: ${GITEA_RUNNER_EPHEMERAL:-0}"
echo "=== END DEBUG ==="

# DNS resolution test
echo "=== DNS Test ==="
nslookup "${GITEA_INSTANCE_URL#https://}" | head -n 5 || echo "DNS lookup failed"
echo "=== END DNS ==="

# Verbose connectivity test (no --insecure; fatal)
echo "=== Connectivity Test (Verbose) ==="
if ! curl -v -f --max-time 10 -s "${GITEA_INSTANCE_URL}/api/v1/version" > /dev/null 2>&1; then
  echo "❌ Connectivity FAILED! Verbose output above—likely firewall (ensure port 443 open to all)."
  exit 1
fi
echo "✓ Connectivity OK! (API version fetched)"
echo "=== END CONNECTIVITY ==="

# Conditional registration
cd /data
if [ ! -f .runner ]; then
  echo "No .runner—registering..."
  if ! /usr/local/bin/act_runner register; then
    echo "❌ Registration FAILED!"
    exit 1
  fi
  echo "✓ Registered! .runner created."
else
  echo "✓ .runner exists."
fi

# Start daemon
echo "Starting daemon..."
exec /usr/local/bin/act_runner daemon