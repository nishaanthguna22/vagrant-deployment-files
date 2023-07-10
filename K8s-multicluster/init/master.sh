#!/bin/bash
#
set -euxo pipefail

# Update /etc/hosts
echo "${API_SERVER_IP} ${CLUSTER_NAME} >> /etc/hosts"
# [ToDo] Check if this is reflected after build completes

# control plane init and image pull
kubeadm config images pull
kubeadm init --apiserver-advertise-address=$API_SERVER_IP --apiserver-cert-extra-sans=$API_SERVER_IP --pod-network-cidr=$POD_CIDR --service-cidr=$SERVICE_CIDR --node-name=$CLUSTER_NAME --ignore-preflight-errors=all
echo "[-+-+-+-+-+-+-+-+!K8S Control Panel Up!-+-+-+-+-+-+-+-+]"

# copy token script and kubeconfig from master
kubeadm token create --print-join-command | tee /vagrant/node_join.sh
cp /etc/kubernetes/admin.conf /vagrant/admin.config
echo "[-+-+-+-+-+-+-+-+!K8S Credentials copied to host OS /vagrant folder!-+-+-+-+-+-+-+-+]"

# copy kube config to master home folder 
mkdir -p /home/vagrant/.kube
cp /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown -R vagrant: /home/vagrant
echo "[-+-+-+-+-+-+-+-+!K8S Credentials exported to /home/vagrant/.kube/!-+-+-+-+-+-+-+-+]"