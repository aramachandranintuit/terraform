#!/bin/bash
cd /Users/ajay.ramachandran/Documents/devops/terraform
workspaceName=workspace-`date +%s`
mkdir "${workspaceName}"
cd "${workspaceName}"
cp ../aws_ec2.tf .
cp ../output.tf .
cp ../variables.tf .
cp ../delete_resources.sh .
terraform init -input=false 
terraform plan -var 'server_port=8080' -var 'AMI=ami-0cd91f65f6fe8a139' -input=false 
terraform apply -var 'server_port=8080' -var 'AMI=ami-0cd91f65f6fe8a139' -auto-approve
