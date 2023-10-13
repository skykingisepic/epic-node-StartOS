#!/bin/bash

DURATION=$(</dev/stdin)
if (($DURATION <= 6000 )); then
    exit 60
fi

sync=$(curl -s -H 'content-type: text/plain;' http://localhost:3413/v1/status | grep sync_status)
ht=$(curl -s -H 'content-type: text/plain;' http://localhost:3413/v1/status | grep height)

error_code=$?
if [ $error_code -ne 0 ]; then
    echo $result >&2
    exit $error_code
fi

if [[ "$sync" == *"no_sync"* ]]; then
  echo "Node Synced and Running. Blockchain height: ${ht:14:7}" >&2
  exit 0 #Success
elif [[ "$sync" == *"awaiting"*  || "$sync" == *"body_sync"* || "$sync" == *"header_sync"* ]]; then
  echo "Node is Syncing...Blockchain height: ${ht:14}" >&2
  exit 61 # Loading
else
  echo "Check Node Status via ssh" >&2
  exit 1 #Error
fi


