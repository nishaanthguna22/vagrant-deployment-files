# Kubernetes Cluster Setup using Minikube on Vagrant 
    
Once the virtualbox is created, using provisioning scripts, minikube and docker runtime are installed on the node.

💀 Change the default and root user's password for all the boxes once they are created.

## Access to Minikube Cluster 

If everything runs smoothly, you should have minikube installed on the guest machine. Minikube spawns a K8s cluster by creating a VM (with it's own network) and the API Server is reachable from inside the Vagrant VM. SSH into the Vagrant box and initiate the cluster, once done credentials will be exported to the default user's directory.

```bash 
$ vagrant ssh k8s-master
Last login: Mon Jul 17 18:25:14 2023 from 10.0.2.2
[vagrant@enron ~]$

<add more>
```

## Project Structure

```bash
\d\multi-k8s$ tree .
.
├── README.md
├── Vagrantfile     Contains global vars like IP, VM related config, versions of software 
├── init
│   ├── common.sh   Commands to install dependencies, restart daemons, set up networking

1 directory, 3 files
```

## Security

[ ] Add firewall rules to block ports and see if it is possible to block outbound internet connection after the cluster inits. <br>
[ ] Add container runtime checks and persist/start the daemons as non-root <br>
[ ] Add more minikube commands <br>
[ ] Check if K8s IP can be forwarded to the host <br>