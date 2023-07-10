#!/bin/bash

# Print the commands executed, fail immediately on exit codes and better error handling
set -euxo pipefail

# Update /etc/hosts
echo "${API_SERVER_IP} ${CLUSTER_NAME} >> /etc/hosts"
for n in {1..${WORKER_NODES}}; do 
    echo "${WORKER_IP_RANGE}$((37+${n})) $CLUSTER_NAME >> /etc/hosts"
done
cat /etc/hosts