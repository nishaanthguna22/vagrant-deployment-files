# Kubernetes Cluster Setup using Vagrant 

The `Vagrantfile` in this repository creates three different virtual machines, using Oracle VM VirtualBox's adapters, and base OS as Ubuntu. 

Once the virtualbox is created, using provisioning scripts, Kubernetes and CRI runtime is installed on all the three nodes. One of the nodes acts as the Kubernetes master aka control plane, while the other two nodes join the cluster to act as workers. 

*Note: Testing was done from a Windows machine with VirtualBox's adapter. It should work smoothly on other distros as well, tweak the version numbers, provider, vm runtime, network adapters if something isn't supported on your distro or doesn't work.*

---

## Installation

 [Download Vagrant](https://developer.hashicorp.com/vagrant/downloads) <br>
[Install Provider](https://www.virtualbox.org/wiki/Downloads) <br>

[List of Providers](https://developer.hashicorp.com/vagrant/docs/providers)

Do a `vagrant up` from the cloned repo, once the build is complete, you should see something like:

```bash
\d\multi-k8s>vagrant status
Current machine states:

k8s-master                running (virtualbox)
k8s-worker-1              running (virtualbox)
k8s-worker-2              running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

If any of the init scripts fail after the virtualboxes are created, destroy the failed boxes and run `vagrant up --no-provision` to disable scripts and debug manually using SSH.

Alternatively, if you want to run a specific one, use `--provision --with-provision nameofprovision`

```bash
\d\multi-k8s>vagrant ssh k8s-master
Welcome to Ubuntu 22.04.2 LTS (GNU/Linux 5.15.0-67-generic x86_64)

vagrant@enron:~$ whoami && id
vagrant
uid=1000(vagrant) gid=1000(vagrant) groups=1000(vagrant),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),110(lxd)
```

*Note: If you are tweaking any of the configuration values, it is recommended the resources related to core Kubernetes deployment are of the same version and if changing the OS, you might have to change the APT source files hardcoded in the scripts*

---

## Access to Kubernetes 

If everything is running smoothly as intended, you should have a copy of the K8S cluster admin configuration and a token for joining the cluster as a worker node in the project directory after build succeeds.

Vagrant by default mounts a shared folder /vagrant which can be accessed from the host machine.

```bash
\d\multi-k8s$ cat node_join.sh
kubeadm join 192.168.13.37:6443 --token redacted --discovery-token-ca-cert-hash sha256:redacated

\d\multi-k8s$ cat kube.config
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMvakNDQWVhZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRH.....
```

All the assets must be reachable from the host OS, update the hosts file if needed. The control plane should be up on 192.168.13.37 and the worker nodes 38, 39.

```bash
\d\multi-k8s>ping 192.168.13.37

Pinging 192.168.13.37 with 32 bytes of data:
Reply from 192.168.13.37: bytes=32 time=1ms TTL=64

\d\multi-k8s>nmap -vv -p6443 -Pn -n 192.168.13.37
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times may be slower.
Starting Nmap 7.94 ( https://nmap.org ) at 2023-07-05 23:20 GMT Daylight Time

PORT     STATE SERVICE      REASON
6443/tcp open  sun-sr-https syn-ack ttl 64

Nmap done: 1 IP address (1 host up) scanned in 4.38 seconds
           Raw packets sent: 2 (72B) | Rcvd: 2 (72B)

```

You can interact with the cluster using the K8S admin credentials after installing kubectl on the host machine.

Copy the cluster configuration to $HOME/.kube/config for kubectl to automatically pick up the configuration file.

```bash
\d\multi-k8s$ kubectl get nodes --kubeconfig kube.config
NAME                            STATUS   ROLES           AGE    VERSION
enron.corp.k8s.local            Ready    control-plane   107m   v1.27.1
enron.corp.k8s.local.9f2783ec   Ready    <none>          55m    v1.27.1
enron.corp.k8s.local.a0d64a59   Ready    <none>          60m    v1.27.1

\d\multi-k8s$ kubectl auth can-i '*' '*'
yes
```
*Currently, there is no way to gracefully shut down the k8s resources, so you might have to `vagrant suspend machine` and save the state to reload it later or destroy the entire box and bring it up.*

---

## Project Structure

```bash
\d\multi-k8s$ tree .
.
├── README.md
├── Vagrantfile     Contains global vars like IP, VM related config, versions of software 
├── Manifests       Contains K8S manifests to create roles, ns, pods and so on
├── init
│   ├── common.sh   Commands to install dependencies, restart daemons, set up networking
│   ├── master.sh   Commands to bring up the control plane server, configuration copy to host 
│   └── node.sh     Commands to run before joining the cluster
├── kube.config     Credential file with admin privs
└── node_join.sh    Token to join the cluster

1 directory, 7 files
```

---

## Security

[ ] Fuck knows why PasswordAuthentication disabled is not reflected during sshd restart. <br>
[ ] Add firewall rules to block ports and see if it is possible to block outbound internet connection after the cluster inits. <br>
[ ] Create a new user in the vagrant box and add the user to the cluster. Don't export the admin credentials outside the box. <br>
[ ] Add container runtime checks and persist/start the daemons as non-root <br>