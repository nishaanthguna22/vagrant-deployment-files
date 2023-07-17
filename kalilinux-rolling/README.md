# Kali Linux Setup using Vagrant 
    
Kali Linux is installed on the VM after vagrant brings it up. Currently, all the tools gets installed. There should be a way to build the image from scratch installing only specific tools and not using insecure defaults (keys, password).  

💀 Change the default vagrant user's password for all the boxes once they are created.

## Project Structure

```bash
\d\multi-k8s$ tree .
.
├── README.md
├── Vagrantfile     Contains global vars like IP, VM related config, versions of software 

0 directory, 2 files
```

## Security

[ ] Change the build script to create a [new box](https://gitlab.com/kalilinux/build-scripts/kali-vagrant/-/blob/master/scripts/vagrant.sh) <br>
[ ] [Build Scripts](https://gitlab.com/kalilinux/build-scripts/kali-vm) <br>
[ ] [Dev](https://www.kali.org/docs/development/live-build-a-custom-kali-iso/) <br> 
[ ] [Metapackages](https://www.kali.org/docs/general-use/metapackages/) <br>