#!/bin/bash

DURATION=$(</dev/stdin)
if (($DURATION <= 6000 )); then
    exit 60
fi

sync=$(curl -s -S http://localhost:3413/v1/status | grep sync_status)
ht=$(curl -s -S http://localhost:3413/v1/status | grep height)

ec=$?
if [ $ec -ne 0 ]; then
  if test "$ec" = "7" || test "$ec" = "1"; then
    echo "Node Not Running - Check Status via ssh" >&2
    exit 1
  fi
fi

if [[ "$sync" == *"no_sync"* ]]; then
  echo "Node Synced and Running. Blockchain height: ${ht:14:7}" >&2
  exit 61 #Success is 0 but no echo just default manifest msg
elif [[ "$sync" == *"awaiting"*  || "$sync" == *"body_sync"* || "$sync" == *"header_sync"* ]]; then
  echo "Node is Syncing...Blockchain height: ${ht:14}" >&2
  exit 61 # Loading
else
  echo "Check Node Status via ssh" >&2
  exit 1 #Error
fi

