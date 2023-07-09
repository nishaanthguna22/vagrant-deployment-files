#!/bin/bash
#
set -euxo pipefail

# [ToDo] update /etc/hosts programatically 
# update the hostname to ensure there is no collision 
hostname ${CLUSTER_NAME}.$(echo $(date +%s | md5sum) | cut -c 1-8)

# join the cluster
sh /vagrant/node_join.sh
echo "[-+-+-+-+-+-+-+-+!Worker node joined successfully!-+-+-+-+-+-+-+-+]"

# all the nodes are assigned same IP which causes so many f problems - fix on priority
# monkey patch : add --node-ip= in Environment of /etc/default/kubelet.service.d/.conf file