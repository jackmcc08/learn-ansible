## 1.2 Configure Target Host 

### <u>Dependencies</u>
- This tutorial assumes you already have a target machine (whether a VM or Physical Machine)
- Follow lesson [1.3](../1.3_Build_Azure_VM/) to create an Azure VM using Ansible

***

### <u>Tutorial</u>

#### __Step 1 - Configure passwordless SSH:__

1. Create an SSH Key on your Control Host
> NOTE if you set up the VM using Lesson 1.3 you will not need to set up a new SSH key.

```bash
ssh-keygen -m PEM -t rsa -b 4096
```

2. Ensure the Private Key is stored on your Control Host 


3. Copy over the SSH Key to the target hosts

4. Ensure your designated user can SSH into the box without the password

5. Check SSH works

#### __Step 2 - Install dependencies:___
For ansible modules that run Ansible generate Python code, the target host needs to be able to run python. This will be detailed in the module documentation

Install Python (if not already installed):
```bash 
sudo apt install python3 -y
```

***
### <u>Set up an Azure Linux VM using Ansible</u>

The below instructions are taken from this guide and simplified for the purpose of this tutorial 
- [Microsoft Guide](https://learn.microsoft.com/en-us/azure/developer/ansible/vm-configure?tabs=ansible)