# Kubernetes Cluster Setup using Minikube on Vagrant 
    
Once the virtualbox is created, using provisioning scripts, Kubernetes and docker runtime is installed on the node.

💀 Change the default  and root user's password for all the boxes once they are created.

## Access to Minikube Cluster 

If everything is running smoothly as intended, you should have minikube up and running on the VM and the API Server exposed on port 8443.

```bash 
$ minikube start
😄  minikube v1.30.1 on Centos 8.5.2111
✨  Automatically selected the docker driver. Other choices: none, ssh

🧯  The requested memory allocation of 1976MiB does not leave room for system overhead (total system memory: 1976MiB). You may face stability issues.
💡  Suggestion: Start minikube with less memory allocated: 'minikube start --memory=1976mb'

📌  Using Docker driver with root privileges
👍  Starting control plane node minikube in cluster minikube
🚜  Pulling base image ...
🔥  Creating docker container (CPUs=2, Memory=1976MB) ...
🐳  Preparing Kubernetes v1.26.3 on Docker 23.0.2 ...
    ▪ Generating certificates and keys ...
    ▪ Booting up control plane ...
    ▪ Configuring RBAC rules ...
🔗  Configuring bridge CNI (Container Networking Interface) ...
    ▪ Using image gcr.io/k8s-minikube/storage-provisioner:v5
🔎  Verifying Kubernetes components...
🌟  Enabled addons: default-storageclass, storage-provisioner
🏄  Done! kubectl is now configured to use "minikube" cluster and "default" namespace by default
```



## Project Structure

```bash
\d\multi-k8s$ tree .
.
├── README.md
├── Vagrantfile     Contains global vars like IP, VM related config, versions of software 
├── init
│   ├── common.sh   Commands to install dependencies, restart daemons, set up networking

1 directory, 7 files
```

## Security

[ ] Disable vagrant user and use a custom private key by default. <br>
[ ] Add firewall rules to block ports and see if it is possible to block outbound internet connection after the cluster inits. <br>
[ ] Add container runtime checks and persist/start the daemons as non-root <br>