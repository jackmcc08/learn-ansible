## 1.1 Configure Control Host 

> NOTE: all of the below instructions are taken from various sources, the code outlined is just one way of setting up your control host and is my preferred set up.

### <u>Quick-Start</u>
- Assuming you have a linux machine, you can run the script in this folder to set up python and ansible-core. 
    - Quickstart Script: [bash script](./quickstart.sh)
***

### <u>Tutorial</u>

#### Requirements: 
- Ansible must be run from a Linux Machine
- The control host must be capable of running python
    - Python 3.8 
- The control host must be able to connect to the target hosts


#### :rocket: __Step 1 - Create a Linux Machine:__
There are multiple ways to create a linux machine, including: 
- Create a VM in a cloud environment [guide](https://learn.microsoft.com/en-us/azure/developer/ansible/install-on-linux-vm?tabs=azure-cli#create-a-virtual-machine)
- Use WSL on a windows machine [guide](https://learn.microsoft.com/en-us/windows/wsl/setup/environment)
- Install a linux OS on your own hardware [guide](https://ubuntu.com/tutorials/install-ubuntu-desktop#1-overview)

This tutorial will not cover how to create a linux machine, but the provided links can help you. 

The following commands assume you are using: 
- Ubuntu 22.04 or 24.04

#### :rocket: __Step 2 - Install Python Dependencies:__

Install python3 and pip

```bash
sudo apt update

# Optional - Upgrade system 
# sudo apt -y upgrade

# Check if python3 is installed 
python3 -V
# you need minimum 3.8

# Install python3
sudo apt install python3 -y

# Install Pip package manager

sudo apt install -y python3-pip
```

#### :rocket: __Step 3 - Install Ansible (ansible-core):__

Ansible can be installed as either `ansible` or `ansible-core`. 

`ansible` contains many additional collections that extend ansible.
`ansible-core` is a lightweight installation which does not contain additional collections by default, but these can be installed as necessary. 

In this guide we will install `ansible-core`
- [For futher installation options - Extended Ansible Installation Guide](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible)

> NOTE: Depending on your preferences you may wish to install python packages in a virtual environment, in this tutorial we will not use this.

> NOTE: For ubuntu install ansible via pip not apt.

```bash 
# Install ansible-core
python3 -m pip install --user ansible-core
# If you need to install system wide
python3 -m pip install --user ansible-core --break-system-packages
# If you have pipx installed
pipx install ansible-core --upgrade
```
***


### :bulb: __INFO Section: Extending Ansible and Installing Dependencies__

Depending on what you are trying to do, you can extend Ansible through additional roles and collections. 

**Roles and Collections**
- Roles and collections can generally be installed through ansible-galaxy. 
- [Ansible User Guide](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html)

> NOTE: most roles are definied as part of a collection, but you can install individual roles as well.
```bash
# Install a collection 
ansible-galaxy collection install <collection-name>
# e.g.
ansible-galaxy collection install azure.azcollection

# Install a role 
ansible-galaxy install <role-name>
# e.g.
ansible-galaxy install geerlingguy.apache
```

**Python Dependencies**
- Some ansible modules and plugins have python dependencies which need to be installed. 
- Typically the module guidance will detail what needs to be installed. 
- e.g. [Azure Collection](https://github.com/ansible-collections/azure?tab=readme-ov-file#requirements)

```bash
# With pip
sudo pip3 install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements.txt

# With pipx
pipx runpip ansible install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements.txt
```

**Requirements Files**

If you have a playbook which has different dependencies on roles and collections then you can define them in a requirements file and install them all by referencing the file. 

1. define the requirements in `requirements.yml`

```yaml
---
# EXAMPLE Requirements.yml file
collections:
    # from galaxy
    - name: kubernetes.core
    version: ">=3.2.0"
    - name: ansible.posix
    version: ">=1.5.4"
    - name: community.general
    version: ">=9.1.0"

roles:
  # Install a role from Ansible Galaxy.
  - name: geerlingguy.java
    version: "1.9.6" # note that ranges are not supported for roles
```

2. Install using ansible-galaxy
```bash
ansible-galaxy install -r ./requirements.yml
```
