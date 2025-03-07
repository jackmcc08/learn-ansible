## LESSON 2: Intro to Ansible

### <u>Dependencies</u>
- This tutorial assumes you have followed the steps in [Lesson 1 - Set Up](../1_SetUp/)
- You will need: 
    - A Control Host
    - One or more Target Hosts
    - The Public IP Address of each Target Host
    - The SSH key to access each Target Host

***

### <u>Tutorial</u>

#### __Step 1 - Set up your inventory:__

- Create the inventory file in a directory
```bash
mkdir ~/intro-to-ansible

touch ~/intro-to-ansible/inventory.yml
nano ~/intro-to-ansible/inventory.yml 

```

- Populate the inventory file with the below information
    - see the [example](./inventory.yml)

```yaml
test_group:
  hosts:
    node1:
      ansible_host: <insert_ip>
  vars:
    ansible_ssh_private_key_file: <path_to_private_key_file>
    ansible_user: <user_you_set_up_on_vm>
    ansible_python_interpreter: /usr/bin/python3

alternative_group:
  hosts: 
    node1:

```

#### __Step 2 - Set up your playbook:__
- create the playbook in your directory
```bash
touch ~/intro-to-ansible/myFirstPlaybook.yml
nano ~/intro-to-ansible/myFirstPlaybook.yml 
```

- Populate the playbook file with the below information
    - see the [example](./myFirstPlaybook.yml)

```yaml

```


#### __Step 3 - Install your requirements from the modules:__
- create the requirements file in your directory
```bash
touch ~/intro-to-ansible/requirements.yml
nano ~/intro-to-ansible/requirements.yml 
```

- Populate the playbook file with the below information
    - see the [example](./requirements.yml)

```yaml
---

collections:
# from galaxy
- name: community.general
  version: ">=9.1.0"
```

- install the dependencies
```bash
ansible-galaxy install -r ~/intro-to-ansible/requirements.yml
```

#### __Step 4 - Run your playbook:__

1. First we are going to test you can ping your virtual machine
```bash
HOST_GROUP=test_group
ansible $HOST_GROUP -m ping -i ~/intro-to-ansible/inventory.yml

HOST=node1
ansible $HOST -m ping -i ~/intro-to-ansible/inventory.yml
```

>OUTPUT: you should see ansible output with a response of PONG to your PING! 

2. Run the playbook you created
```bash
ansible-playbook -i ~/intro-to-ansible/inventory.yml ~/intro-to-ansible/myFirstPlaybook.yml 
```

> OUTPUT: you should see something similar to the below: 

#### __Step 5 - Cleanup:__
- Go and delete any VMs you created for the lesson - see lesson [1.4 Remove Azure VMs](../1_SetUp/1.4_Remove_Azure_VM/)
- If you have exposed any VMs on the public internet, then consider removing the connection if it is no longer required.