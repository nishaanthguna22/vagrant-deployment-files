#!/bin/bash

# Print the commands executed, fail immediately on exit codes and better error handling
set -euxo pipefail

# First APT update, add any software/repo sources you want at init 
apt-get update -y

# Turn swap off even during reboot
swapoff -a
(crontab -l 2>/dev/null; echo "@reboot /sbin/swapoff -a") | crontab - || true

# Add the DNS entry to resolve daemon
if [ ! -d /etc/systemd/resolved.conf.d ]; then
    mkdir /etc/systemd/resolved.conf.d/
fi
cat <<EOF | tee /etc/systemd/resolved.conf.d/dns_servers.conf
[Resolve]
DNS=${DNS_SERVER}
EOF
systemctl restart systemd-resolved

# Install container runtime and persist changes after reboot
cat <<EOF | tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /
EOF
cat <<EOF | tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$CRI_VERSION.list
deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$CRI_VERSION/$OS/ /
EOF

curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$CRI_VERSION/$OS/Release.key | apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | apt-key --keyring /etc/apt/trusted.gpg.d/libcontainers.gpg add -

apt-get update -y
apt-get install cri-o cri-o-runc -y
systemctl daemon-reload
systemctl enable crio --now

if [ ! -d /etc/modules.load.d/ ]; then
    mkdir /etc/modules.load.d/
fi
cat <<EOF | tee /etc/modules.load.d/crio.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

cat <<EOF | tee /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sysctl --system

# Install K8S 
apt-get install -y apt-transport-https ca-certificates curl
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --batch --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list

apt-get update -y
apt-get install -y jq kubelet="$KUBERNETES_VERSION" kubectl="$KUBERNETES_VERSION" kubeadm="$KUBERNETES_VERSION"

# Update the node IP to use eth1 host-only interface instead of VM's eth0 (10.0.2.15) - https://github.com/kubernetes/kubeadm/issues/203
NODE_IP_ADDRESS=$(ip addr show dev eth1 | awk 'match($0,/inet (([0-9]|\.)+).* scope global eth1$/,a) { print a[1]; exit }')
echo "Updating node ip matching eth1 interface:" $NODE_IP_ADDRESS
echo "Environment=\"KUBELET_EXTRA_ARGS=--node-ip=$NODE_IP_ADDRESS\"" >> /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

systemctl daemon-reload
systemctl restart kubelet