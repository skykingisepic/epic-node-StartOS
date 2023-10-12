#!/bin/bash

DURATION=$(</dev/stdin)
if (($DURATION <= 6000 )); then
    exit 60
fi

result=$(curl -s -H 'content-type: text/plain;' http://localhost:3413/v1/status | grep no_sync)

error_code=$?
if [ $error_code -ne 0 ]; then
    echo $result >&2
    exit $error_code
fi

if [[ "$result" == *"no_sync"* ]]; then
  echo "Node Synced and Running..." >&2
  exit 61
elif [[ "$result" == *"awaiting"* ]]; then
  echo "Node is Syncing..." >&2
  exit 61
else
  echo "Check Node Status via ssh" >&2
  exit 61
fi

