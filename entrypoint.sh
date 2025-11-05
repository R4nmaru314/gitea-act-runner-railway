#!/bin/sh
cd /data
if [ ! -f .runner ]; then
  /usr/local/bin/act_runner register || exit 1
fi
exec /usr/local/bin/act_runner daemon