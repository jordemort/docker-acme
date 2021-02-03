#!/bin/sh
set -e

export LE_WORKING_DIR=${LE_WORKING_DIR:-/home/acme/.acme.sh}
export LE_CONFIG_HOME=${LE_CONFIG_HOME:-/data}

if [ ! -e "$LE_CONFIG_HOME/account.conf" ] ; then
  cp /home/acme/default.account.conf "$LE_CONFIG_HOME/account.conf"
fi

if [ "$#" -gt 0 ] ; then
  exec "$LE_WORKING_DIR/acme.sh" "$@"
fi

ACME_SLEEP=${ACME_SLEEP:-3600}

while true; do
  acme.sh cron
  echo "$0: Going to sleep for $ACME_SLEEP seconds"
  sleep "$ACME_SLEEP"
done
