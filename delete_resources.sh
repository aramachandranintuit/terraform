#!/bin/bash
# aws ec2  terminate-instances --instance-ids `(terraform output instance_id -json | jq '.value[0]')`
# sleep 30s
# aws ec2 detach-internet-gateway --internet-gateway-id `(terraform output gateway_id)` --vpc-id `(terraform output vpc_id)`
# aws ec2 delete-internet-gateway --internet-gateway-id `(terraform output gateway_id)`
# aws ec2 delete-subnet --subnet-id `(terraform output subnet_id -json | jq '.value[0]')`
# aws ec2 delete-security-group --group-id `(terraform output security_group)`
# aws ec2 delete-vpc --vpc-id `(terraform output vpc_id)`

terraform output -json instance_id | jq '.value[]' | sed 's/"//g' > subnet1_instance_ids.txt
for a in `cat subnet1_instance_ids.txt`; do aws ec2  terminate-instances --instance-ids $a; done

terraform output -json instance_id1 | jq '.value[]' | sed 's/"//g' > subnet2_instance_ids.txt
for a in `cat subnet2_instance_ids.txt`; do aws ec2  terminate-instances --instance-ids $a; done

# sleep 30s
# until aws ec2 detach-internet-gateway --internet-gateway-id `(terraform output gateway_id | sed 's/"//g')` --vpc-id `(terraform output vpc_id | sed 's/"//g')` >/dev/null 2>&1;
#  do
#  	echo "waiting for instances to terminate"
#     sleep 10s 
#  done
#     aws ec2 delete-internet-gateway --internet-gateway-id `(terraform output gateway_id | sed 's/"//g')`
# 	aws ec2 delete-subnet --subnet-id `(terraform output -json subnet_id | jq '.value[0]'| sed 's/"//g')`   
# 	aws ec2 delete-subnet --subnet-id `(terraform output -json subnet_id1 | jq '.value[0]'| sed 's/"//g')`   
