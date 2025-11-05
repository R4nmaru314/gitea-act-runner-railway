#!/bin/sh

echo "Runner config: NAME=${GITEA_RUNNER_NAME}, LABELS=${GITEA_RUNNER_LABELS}, EPHEMERAL=${GITEA_RUNNER_EPHEMERAL:-0}"

# Start the actual runner daemon
exec /usr/local/bin/act_runner daemon