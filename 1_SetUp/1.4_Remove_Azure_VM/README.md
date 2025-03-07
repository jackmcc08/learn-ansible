## 1.4 Remove Azure VM

This is an example tutorial using Azure and Ansible to create a VM as target machine for the purpose of the tutorial. This tutorial is to remove the VM created in lesson [1.3](../1.3_Build_Azure_VM/README.md)

The Ansible Code will be run on your managed node and you will need a personal Azure Subscription with some credit in it. 

> This tutorial is based on this [Microsoft Guide](https://learn.microsoft.com/en-us/azure/developer/ansible/vm-configure?tabs=ansible)

### <u>Dependencies</u>
- You will need a service principle for your Azure Subscription. See lesson 1.3 and follow the guidance there.

***

### <u>Tutorial</u>

1. Create the playbook delete_rg.yml
- Update the details in [delete_rg.yml](./delete_rg.yml)

> NOTE: you can also override defined variables in the command line. 
    - See guide on variable precedence [Link](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_variables.html#understanding-variable-precedence)

2. Run the playbook

```bash
# If you want to use extra vars include the --extra-vars command
RG_NAME=myResourceGroup
ansible-playbook delete_rg.yml --extra-vars "name=$RG_NAME"
```