Andrei Mendoza(A01383138) + Tobias Chau (A01234785)

# General Setup

## Install Terraform
### **Use the following commands:**
```bash
#install gnupg if not already installed
sudo apt-get install -y gnupg
#install lsb-release if not already installed
sudo apt-get install -y lsb-release
# get gpg keys to identify the hashicorp developers who maintain the repo
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
# add repo to list of package repositories
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

### update repositories and install Terraform
sudo apt update && sudo apt install terraform
```
**Note**: You may need to install 
# Creating a SSH key pair
## To create a key pair:
**Use the following command (replacing KEY NAME for the desired name):**

ssh-keygen -t ed25519 -C "KEY NAME"

# Configuring Cloud Config File
## Clone made Repository and enter the scripts directory 
```bash
sudo apt update
sudo apt-get install git #if you do not have git installed

#Git repository provided by the professor
git clone https://gitlab.com/cit_4640/4640-w4-lab-start-w25.git

cd path/to/scripts/cloud-config.yaml

sudo nano cloud-config.yaml
```
While editing the cloud-config.yaml, paste in the <ssh_key.pub> content into the designated area: 
```bash
#config-config
users:
  - name: web
    primary_group: web
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh-authorized-keys:
      - "ssh-ed25519 <SSH Key Sequence> <Key_Name>"
```
Once completed, you can add this underneath the yaml file to install the **nginx** and **nmap** packages. 
This was provided by https://cloudinit.readthedocs.io/en/latest/index.html
```bash
package_reboot_if_required: true
package_update: true
package_upgrade: true
packages:
  - nginx
  - nmap
```

# Running Terraform
## Initialize Terraform
```bash
terraform fmt
terraform validate
terraform init
```




