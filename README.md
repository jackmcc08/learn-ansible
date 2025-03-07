# Ansible Lessons by Jack  

Follow the lessons in order to start using Ansible. 

- [Section 1](./1_SetUp/) covers setting up the control node and the target hosts
    - [Lesson 1.1](./1_SetUp/1.1_Configure_Control_Host/) Configure the Control Host
    - [Lesson 1.2](./1_SetUp/1.2_Configure_Target_Hosts/) Configure the Target Host (you need some target machines first)
    - [Lesson 1.3](./1_SetUp/1.3_Build_Azure_VM/) Build an Azure VM using Ansible (builds one target machine)
            - This lesson also generates a public IP for you to access the Nginx server from.
    - [Lesson 1.4](./1_SetUp/1.4_Remove_Azure_VM/) Remove an Azure VM (Do this after completing Section 2)

- [Section 2](./2_Intro_to_Ansible/) covers running your first playbook
    - You run two playbooks
    - The first one installs Nginx 
    - The second one modifies the main page of Nginx and restarts the service
