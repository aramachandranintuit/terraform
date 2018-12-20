#!/bin/bash
if [ -f webservers ]
then
	rm webservers
fi

touch webservers
echo "[webservers]" > webservers
terraform output -json address1 | jq '.value[]' | sed 's/"//g' >> webservers
terraform output -json address | jq '.value[]' | sed 's/"//g' >> webservers
echo "[all:vars]" >> webservers
echo "ansible_ssh_private_key_file=/Users/ajay.ramachandran/Downloads/code_deploy_app.pem" >> webservers
