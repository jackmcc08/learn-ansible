## 1.3 Configure Target Host 

### <u>Dependencies</u>
- This tutorial assumes you already have a target machine (whether a VM or Physical Machine)
- Follow lesson [1.2](../1.2_Build_Azure_VM/) to create an Azure VM using Ansible

***

### <u>Tutorial</u>

#### :rocket: __Step 1 - Configure passwordless SSH:__
- This guide is based on this tutorial [DigitalOcean SSH key guide](https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server)

1. Create an SSH Key on your Control Host
> NOTE if you set up the VM using Lesson [1.2](../1.2_Build_Azure_VM/) you will not need to set up a new SSH key.

```bash
ssh-keygen -m PEM -t rsa -b 4096
# Enter the file name - default id_rsa
# Enter with NO passphrase
```

2. Ensure the Private Key is stored on your Control Host 
- you will need to reference the private key file in the ansible inventory file

3. Copy over the SSH Key to the target hosts
```bash
ssh-copy-id username@remote_host
# Type in the password for the remote host
```

4. Ensure your designated user can SSH into the box without the password
```bash
ssh <username>@<ip address>
```

- You should be able to ssh in without your password
- If you still require your password then you need to update the sshd config on the target machine 

```bash
sudo nano /etc/ssh/sshd_config
# add in the below text
PasswordAuthentication no

# Restart the ssh Service
sudo systemctl restart ssh
```

#### :rocket: __Step 2 - Install dependencies:___
For ansible modules that run Ansible generate Python code, the target host needs to be able to run python. This will be detailed in the module documentation

Install Python (if not already installed):
```bash 
sudo apt install python3 -y
```
