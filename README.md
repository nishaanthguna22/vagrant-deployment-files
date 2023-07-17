#  Getting started using Vagrant 

Vagrant utilizes the 'Vagrantfile' found within a sub-folder of this repository to generate multiple virtual machines and perform various actions based on the configuration. These actions involve fetching the required operating system, packages, and performing installations and tweaking to set up and initialize the desired service. For specific instructions on alternative building methods, kindly refer to the corresponding sub-folder of the project.

By default, Vagrant establishes a shared folder named '/vagrant' that is accessible from the host machine. In many scripts, this mounted folder is utilized to transfer necessary files from the created operating system to the host machine for convenient accessibility.

## Installation

[Install Provider](https://www.virtualbox.org/wiki/Downloads) <br>
[Download Vagrant](https://developer.hashicorp.com/vagrant/downloads) <br>

[List of Providers](https://developer.hashicorp.com/vagrant/docs/providers)

Do a `vagrant up` from the cloned repo, once the build is complete, you should see something like:

```bash
\d\multi-k8s>vagrant status
Current machine states:

machine-1              running (virtualbox)
machine-2              running (virtualbox)
machine-3              running (virtualbox)

This environment represents multiple VMs. The VMs are all listed
above with their current state. For more information about a specific
VM, run `vagrant status NAME`.
```

If any of the init scripts fail after the virtualboxes are created, make sure the failed boxes are destroyed and run `vagrant up --no-provision` to disable scripts and debug manually using SSH.

Alternatively, if you want to run a specific one, use `--provision --with-provision nameofprovision`

Get into the created VM box (SSH port gets forwarded to the local machine) using Vagrant's SSH command

```bash
\d\multi-k8s>vagrant ssh machine-name
Welcome to Ubuntu 22.04.2 LTS (GNU/Linux 5.15.0-67-generic x86_64)

vagrant@enron:~$ whoami && id
vagrant
uid=1000(vagrant) gid=1000(vagrant) groups=1000(vagrant),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),110(lxd)
```

## To Do
[ ] Change default user, root user's creds with a custom built image
[ ] Fix all the issues in `ToDo` comment of the the sub-directories <br>
[ ] Create a workflow for pushing changes to a temp repo -> lock the main branch <br>
[ ] Workflow to prevent secrets into Git <br>
[ ] Pre-commit hooks <br>
[ ] Create a task to rotate keys every N days <br>
