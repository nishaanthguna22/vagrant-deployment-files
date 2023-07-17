#!/bin/bash

# Print the commands executed, fail immediately on exit codes and better error handling
set -euxo pipefail

# Add necessary CentOS mirror repos and update
sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*

# Dependencies for minikube 
yum -y update
yum -y install epel-release
yum -y install libvirt qemu-kvm virt-install virt-top libguestfs-tools bridge-utils
# [ToDo] takes too long to install and setup, check if all the packages are necessary

# Init libvirt daemon and docker
systemctl enable --now libvirtd
systemctl status libvirtd
usermod -a -G libvirt vagrant
sed -i -e '$aunix_sock_group = "libvirt"' /etc/libvirt/libvirtd.conf
sed -i -e '$aunix_sock_rw_perms = "0770"' /etc/libvirt/libvirtd.conf
systemctl restart libvirtd.service  

yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable --now docker
docker version
usermod -aG docker vagrant

# Install Minikube and Kubectl
curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x kubectl
mv kubectl /usr/local/bin/kubectl
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
install minikube-linux-amd64 /usr/local/bin/minikube
rm -rf minikube-linux-amd64