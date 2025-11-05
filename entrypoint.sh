#!/bin/sh
cd /data
if [ ! -f .runner ]; then
  echo "No .runner—registering with flags..."
  if ! /usr/local/bin/act_runner register \
    --instance "${GITEA_INSTANCE_URL}" \
    --token "${GITEA_RUNNER_REGISTRATION_TOKEN}" \
    --name "${GITEA_RUNNER_NAME:-railway-runner}" \
    --labels "${GITEA_RUNNER_LABELS:-alpine-latest:host}" \
    ${GITEA_RUNNER_EPHEMERAL:+--ephemeral}; then  # Optional: --ephemeral if var=1
    echo "❌ Registration FAILED! Check token/URL in logs."
    exit 1
  fi
  echo "✓ Registered! .runner created."
else
  echo "✓ .runner exists—skipping."
fi
exec /usr/local/bin/act_runner daemon