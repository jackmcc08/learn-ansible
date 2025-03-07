## 1.3 Build Azure VM

This is an example tutorial using Azure and Ansible to create a VM as target machine for the purpose of the tutorial. 

The Ansible Code will be run on your managed node and you will need a personal Azure Subscription with some credit in it. 

> NOTE: destroy the VM using lesson 1.4 as soon as possible to avoid incurring additional cost

> This tutorial is based on this [Microsoft Guide](https://learn.microsoft.com/en-us/azure/developer/ansible/vm-configure?tabs=ansible)

### <u>Dependencies</u>
- You will need a personal Azure Subscription [guide](https://azure.microsoft.com/en-us/pricing/purchase-options/azure-account?msockid=2e4db245fd3360862ed4a7edfc88611d) 
- You will need a service principle for your Azure Subscription. See the tutorials here: 
    - [Create a Service Principle](https://learn.microsoft.com/en-us/azure/developer/ansible/create-ansible-service-principal?tabs=azure-cli)
        - Follow the full tutorial
    - [Store secrets for consumption by Ansible](https://learn.microsoft.com/en-us/azure/developer/ansible/install-on-linux-vm?tabs=azure-cli#create-azure-credentials)
        -  I recommend following [option 1](https://learn.microsoft.com/en-us/azure/developer/ansible/install-on-linux-vm?tabs=azure-cli#-option-1-create-ansible-credentials-file) and storing your credentials on the control host 

***

### <u>Tutorial</u>

#### __1. :rocket: Create an SSH Key Pair on your control node__
```bash
ssh-keygen -m PEM -t rsa -b 4096
```

#### __2. :rocket: Create and Update the playbook with your desired configuration__ 
- Enter your preferred details into the playbook
- copy the public key value into the `<key_data>` placeholder
> NOTE: the key data is sensitive and should not be committed into a repo!

#### __3. :rocket: Run the playbook__
> NOTE: there is no inventory file because the commands all run on the localhost (the control node)

```bash
# Install the dependencies
ansible-galaxy collection install azure.azcollection --force 
sudo pip3 install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements.txt


# Run the playbook
ansible-playbook build_azure_vm.yml

```

#### __4. :rocket: Verify the VM exists__
- Requires Azure Command Line installed
- put in the vm name of the one you created
```bash
VM_NAME=myVM
az vm list -d -o table --query "[?name=='$VM_NAME']"
```

#### __5. :rocket: Test connection__
```bash
ssh azureuser@<ip_address> -i /home/azureuser/.ssh/authorized_keys/id_rsa
```