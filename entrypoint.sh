#!/bin/sh
echo "Runner config: NAME=${GITEA_RUNNER_NAME}"
exec /usr/local/bin/act_runner daemon