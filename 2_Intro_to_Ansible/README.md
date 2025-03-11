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

#### :rocket: __Step 1 - Set up your inventory:__

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

#### :rocket: __Step 2 - Set up your playbook:__
- create the playbook in your directory
```bash
touch ~/intro-to-ansible/myFirstPlaybook.yml
nano ~/intro-to-ansible/myFirstPlaybook.yml 
```

- Populate the playbook file with the yaml from the [example](./myFirstPlaybook.yml)

#### :rocket: __Step 3 - Run your First playbook:__

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

> OUTPUT: you should see a play recap saying things have suceeded. 

#### :rocket: __Step 4 - Test deployment:__

1. go to your browser and enter the public ip of your machine - you should now see the NGINX home page 

2. run the first playbook again and you should see that the output has changed=0. This shows Ansible's idempotency.
```bash
ansible-playbook -i ~/intro-to-ansible/inventory.yml ~/intro-to-ansible/myFirstPlaybook.yml 
```

#### :rocket: __Step 5 - Run second playbook:__

In this second playbook we are going to update the home page of the nginx deployment.

This will involve copying over an updated index page and restarting the service. 

- create the playbook in your directory
```bash
touch ~/intro-to-ansible/mySecondPlaybook.yml
nano ~/intro-to-ansible/mySecondPlaybook.yml 
```
- Populate the playbook file with the yaml from the [example](./mySecondPlaybook.yml)

- create the template in your directory
> NOTE: the template needs to be in the same directory as your playbook. Or you need to alter the referencing in the playbook. 
```bash
touch ~/intro-to-ansible/index.html.j2
nano ~/intro-to-ansible/index.html.j2
```
- Populate the playbook file with the yaml from the [example](./index.html.j2)

- Run the playbook 
```bash
ansible-playbook -i ~/intro-to-ansible/inventory.yml ~/intro-to-ansible/mySecondPlaybook.yml 
```

OUTPUT: You should see the playbook run successfully and if you visit the IP address of the VM then you should see the updated home page of NGINX.

#### __Step 6 - Cleanup:__
- Go and delete any VMs you created for the lesson - see lesson [1.4 Remove Azure VMs](../1_SetUp/1.4_Remove_Azure_VM/)
- If you have exposed any VMs on the public internet, then consider removing the connection if it is no longer required.