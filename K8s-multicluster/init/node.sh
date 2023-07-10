#!/bin/bash
#
set -euxo pipefail

# [ToDo] update /etc/hosts programatically 
# update the hostname to ensure there is no collision 
hostname ${CLUSTER_NAME}.$(echo $(date +%s | md5sum) | cut -c 1-8)

# join the cluster
sh /vagrant/node_join.sh
echo "[-+-+-+-+-+-+-+-+!Worker node joined successfully!-+-+-+-+-+-+-+-+]"