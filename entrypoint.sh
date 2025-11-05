#!/bin/sh

# Force Go to use C resolver (better IPv4 fallback with gai.conf)
export GODEBUG=netdns=cgo

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

# DNS resolution test (with IPv4 focus)
echo "=== DNS Test (IPv4 Preferred) ==="
nslookup -type=A "${GITEA_INSTANCE_URL#https://}" | head -n 6 || echo "IPv4 lookup failed"
echo "=== END DNS ==="

# Verbose connectivity test (force IPv4 with -4)
echo "=== Connectivity Test (IPv4 Forced) ==="
if ! curl -v -4 -f --max-time 10 -s "${GITEA_INSTANCE_URL}/api/v1/version" > /dev/null 2>&1; then
  echo "❌ Connectivity FAILED! Verbose output above—check firewall if still issues."
  exit 1
fi
echo "✓ Connectivity OK! (IPv4: API version fetched)"
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