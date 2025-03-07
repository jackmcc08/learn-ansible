#!/bin/bash

sudo apt update

sudo apt install python3 -y

sudo apt install -y python3-pip

python3 -m pip install --user ansible-core
# If you need to install system wide
# python3 -m pip install --user ansible-core --break-system-packages

# if you have pipx installed
# pipx install ansible-core --upgrade

python3 -V

ansible --version
