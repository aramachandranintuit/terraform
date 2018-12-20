#!/bin/bash

cd /Users/ajay.ramachandran/Documents/devops/terraform
terraform init -input=false 
terraform plan -var 'server_port=8080' -var 'AMI=ami-0cd91f65f6fe8a139' -input=false
terraform apply -var 'server_port=8080' -var 'AMI=ami-0cd91f65f6fe8a139' -auto-approve