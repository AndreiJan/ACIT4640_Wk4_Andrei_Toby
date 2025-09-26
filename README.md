# Creating a SSH key pair
## To create a key pair:
**Use the following command (replacing KEY NAME for the desired name):**
```bash
ssh-keygen -t ed25519 -C "KEY NAME"
```
You will be prompted to write a file name where the key will be saved. Write the desired name.

Following that, you can add a password for the private key, but this is optional.

A randomart will be generated, copy and save in a safe place.

You should see two key files in the folder (i.e. my_key and my_key.pub)
Configuring the cloud-init file
