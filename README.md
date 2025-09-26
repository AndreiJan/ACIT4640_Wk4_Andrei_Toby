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

You will be prompted to write a file name where the key will be saved. Write the desired name.

Following that, you can add a password for the private key, but this is optional.

A randomart will be generated, copy and save in a safe place.

You should see two key files in the .ssh folder (i.e. my_key and my_key.pub)

## Configuring the cloud-init file
