## Python Virtual Environment 

These environment allow you to control your dev environment

Ensure your projects do not interfere with each other


- Enter wsl environment

```bash
cd ~
mkdir learn-ansible-2
cd learn-ansible-2

sudo apt install python3 python3-venv
python3 -m venv learn-ansible-venv

source learn-ansible-venv/bin/activate

pip install ansible-core --upgrade 
export PATH=/home/jackmcc08/.local/bin:$PATH

```

# Test access to VMs

Need SSH access to your machines
For our purposes we are using:
Control host (WSL on local machine)
2 Target Hosts (2 VMs in Azure) 
I have set up the hosts previously to speed up this demo.
VM one IP: 51.145.32.173
VM two IP: 51.140.94.120

I have stored the SSH Key on my machine previously


```bash
ssh adminuser@51.145.32.173 –i ~/.ssh/learn-ansible/id_rsa

ssh adminuser@51.140.94.120 –i ~/.ssh/learn-ansible/id_rsa

```

# Create an Inventory File 
The inventory file dictates the list of targets. 

You can use the file to specify key variables related to the inventory: 
IP of VM
RSA Key File
User

We are then going to use the ping module to validate connections.


```yaml
---
test_group:
  hosts:
    myVM-1:
      ansible_host: 51.145.32.173 
    myVM-2:
      ansible_host: 51.140.94.120 
  vars:
    ansible_ssh_private_key_file: ~/.ssh/learn-ansible/id_rsa 
    ansible_user: adminuser
    ansible_python_interpreter: /usr/bin/python3

```

```bash
ansible -i inventory.yml -m ping test_group
```

# Use Ansible Facts
The playbook setup is similar to what we have seen before, note:
hosts
gather_facts
Vars

Build our first task which uses the Debug module from the Ansible Builtin Collection. This prints messages to stdout during the playbook run. 

ansible_facts are gathered at the beginning of the playbook run.
These contain key system information about the target hosts
Ansible Docs - Facts 
https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html 

```yml
- name: My third playbook
  hosts: test_group
  gather_facts: true
  vars:
    vm_one: "myVM-1"
    vm_two: "myVM-2"
  tasks:
    - name: Print key system details from each VMs using ansible_facts
      ansible.builtin.debug:
        msg:
        - "This VM user is: {{ ansible_facts['user_id'] }}"
        - "This VM's IP is: {{ ansible_host }}"
        - "This VM's hostname is: {{ ansible_hostname }}"
        - "This VM's linux distribution is: {{ansible_facts['distribution'] }}"

```

```bash
cd ~/learn-ansible-2
touch myThirdPlaybook.yml

ansible -i inventory.yml myThirdPlaybook.yml
```

# Use Hostvars

When you run Ansible it caches facts about each system on all the other systems. 

This can be accessed through the `hostvars` variable.

You will see with this task how the VMs can prints information about their system and the other target host.
You will also see a demonstration of a list using a magic variable – anisble-play_hosts. 	

Ansible Docs - Facts


```yml
- name: Access cached facts of all systems in the target group using Hostvars
      ansible.builtin.debug:
        msg:
        - "The VM {{ hostvars[item]['ansible_facts']['hostname'] }} ip address is: {{ hostvars[item]['ansible_host'] }}"
      loop: "{{ ansible_play_hosts }}"
```


# Use Loops

You can use loops to run the same task multiple times across each target host. 
The loops allow you to use different variables/inputs for each task run
https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_loops.htm 

```yml
- name: Loop through a list of items and see the task be run multiple times on each host
      ansible.builtin.debug:
        var: looped_item
      loop: 
      - "1. Programming isn't about what you know. It's about what you can figure out. - Chris Pine"
      - "2. Every great developer you know got there by solving problems they were unqualified to solve until they actually did it. - Patrick Mckenzie"
      - "3. It's ok to want to yeet your laptop out the window every now and then. For me it happens at least twice a day. - Jack McCarthy"
      loop_control:
        loop_var: looped_item
```

# Use the when conditional to target the correct host or group of hosts

You can use the when conditional to control when a task is run and on which target host. 

You can get quite complex and clever with the when’s when you combine it with filters. 

Here we are using it to just action any target where the hostname is equal to vm_one

https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_conditionals.html

```yml
- name: Only execute an action on one target host with the When keyword
      ansible.builtin.debug:
        msg: "I was only printed on {{ ansible_hostname }}"
      when: 
      - ansible_hostname == vm_one
```

# Use tags to run specific tasks or skip them.

You can use tags to further control what tasks are run when you run a playbook

If you don’t specify a tags flag then tagged tasks won’t be excluded

There are magic tags which have special meaning – always, never, all, tagged, untagged.

https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html

```yml
- name: Use tags to control which tasks are run
      ansible.builtin.debug:
        msg: "I have the tag - print_me"
      when: 
      - ansible_hostname == vm_one
      tags: 
      - print_me
```

```bash
ansible-playbook -i inventory.yml myThirdPlaybook.yml --tags "print_me"
ansible-playbook -i inventory.yml myThirdPlaybook.yml --skip-tags "print_me"
```

# Use filters to manipulate your data

Filters let you manipulate data 

There are Ansible specific filters, built in filters from Jinja2, python methods and also create custom filters

NOTE: Ansible is not really meant for data manipulation, so if your data needs complex manipulation, it might be better to use a custom filter 

https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_filters.html

```yml
- name: Use filters to control data
      ansible.builtin.debug: 
        msg:
        - "This is my unsorted list: [8,2,3,1]"
        - "This is my sorted list: {{ [8,2,3,1] | sort }}"
        - "This is using a default value if a variable isn't defined: {{ some_variable | default('details!') }}"
      when: 
      - ansible_hostname == vm_one
```

# Use include_tasks and import_tasks to re-use Ansible tasks

With Ansible you can reuse a variety of artefacts, including tasks, playbooks, vars, roles, etc... 

It’s important to remember there is dynamic and static reusing which has different impacts on the way it reusing

Use include_tasks to dynamically run a list of tasks which importantly is affected by previous tasks (e.g. you can use variables generated by previous tasks), this also allows you to loop the reused tasks

Use import_tasks to statically include a list of tasks and these are defined before any other tasks are run. 

Ansible Docs - Reuse Tasks 
https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse.html#playbooks-reuse

```yml
- name: Getting the date to demonstrate dynamic inclusion of tasks
      ansible.builtin.shell: date
      register: vm_date
      when: 
        - ansible_hostname == vm_one

- name: Dynamically including this task
      ansible.builtin.include_tasks: reusable_tasks.yml
      vars:
        type_reuse: "Dynamic"
        test_var: "{{ vm_date.stdout }}"
      when: 
        - ansible_hostname == vm_one

- name: Statically including this task
      ansible.builtin.import_tasks: reusable_tasks.yml
      vars:
        type_reuse: "Static"
        test_var: "{{ vm_date.stdout }}"
      when: 
        - ansible_hostname == vm_one
```
```bash
touch reusable_tasks.yml
```
```yml
---

- name: This is the reused task - type {{ type_reuse }}
  ansible.builtin.debug:
    msg: 
    - "This is the passed down variable: {{ test_var }}“

```

Use Ansible Vault to protect your secrets

Enables you to encrypt secrets and share the files securely. 

You can encrypt variables or entire files.

There are a few ways to secure the files with:
Password
Certificate
Password storage tools

https://docs.ansible.com/ansible/latest/vault_guide/index.html

```yml
 - name: Imports variables from the encrypted file
      ansible.builtin.include_vars:
        file: encrypted_secrets.yml
      when: 
        - ansible_hostname == vm_one
    
- name: Using Ansible Vault to secure variables
      ansible.builtin.debug:
        msg:
        - "This variable was encrypted: {{ secret_var }}"
      when: 
        - ansible_hostname == vm_one

```
```bash
touch encrypted_secrets.yml 

ansible-vault encrypt encrypted_secrets.yml

ansible-playbook -i inventory.yml myThirdPlaybook.yml --ask-vault-pass

```


You can also use client scripts to provide the password from a 3rd party password storage tool. 

Here I have just done a simple python yaml script to print the password

But you could extend it to for example get the password from an Azure Key Vault
https://docs.ansible.com/ansible/latest/vault_guide/vault_managing_passwords.html#storing-passwords-in-third-party-tools-with-vault-password-client-scripts
```py
#!/usr/bin/env python3
import sys

if __name__ == "__main__":
    secret = 'password'

    sys.stdout.write('%s\n' % secret)
```
```bash
touch print-password-client.py
chmod +x print-password-client.py

ansible-playbook -i inventory.yml myThirdPlaybook.yml --vault-id @print-password-client.py 

```



