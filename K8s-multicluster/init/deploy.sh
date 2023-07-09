#!/bin/bash
#
set -euxo pipefail

# [ToDo] add a separate script to gracefully stop all the resources in the n nodes
# [ToDo] create multiple users and assign them different type of auth methods - https://www.adaltas.com/en/2019/08/07/users-rbac-kubernetes/
kubectl create namespace dataengg-preprod --kubeconfig /home/vagrant/.kube/config
# kubectl apply -f /vagrant/manifests/gitlab-runner.yaml
echo "[-+-+-+-+-+-+-+-+!Created resources in the K8S Cluster!-+-+-+-+-+-+-+-+]"
