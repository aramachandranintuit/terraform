#!/bin/bash

terraform output -json instance_id | jq '.value[]' | sed 's/"//g' >> subnet1_instance_ids.txt
for a in `cat subnet1_instance_ids.txt`; do aws ec2  terminate-instances --instance-ids $a; done

terraform output -json instance_id1 | jq '.value[]' | sed 's/"//g' >> subnet2_instance_ids.txt
for a in `cat subnet2_instance_ids.txt`; do aws ec2  terminate-instances --instance-ids $a; done

terraform output -json instance_id2 | jq '.value[]' | sed 's/"//g' >> subnet3_instance_ids.txt
for a in `cat subnet3_instance_ids.txt`; do aws ec2  terminate-instances --instance-ids $a; done

terraform output -json instance_id3 | jq '.value[]' | sed 's/"//g' >> subnet4_instance_ids.txt
for a in `cat subnet4_instance_ids.txt`; do aws ec2  terminate-instances --instance-ids $a; done

until aws elb delete-load-balancer --load-balancer-name Infra-setup-lb >/dev/null 2>&1
 do
 	echo "waiting for VMs to shutdown"
 	sleep 20s
 done

# sleep 30s
until aws ec2 detach-internet-gateway --internet-gateway-id `(terraform output gateway_id | sed 's/"//g')` --vpc-id `(terraform output vpc_id | sed 's/"//g')` >/dev/null 2>&1
 do
 	echo "waiting for instances to terminate"
    sleep 20s 
 done


aws ec2 delete-internet-gateway --internet-gateway-id `(terraform output gateway_id | sed 's/"//g')`

aws ec2 delete-subnet --subnet-id `(terraform output -json subnet_id | jq '.value[0]'| sed 's/"//g')`
aws ec2 delete-subnet --subnet-id `(terraform output -json subnet_id1 | jq '.value[0]'| sed 's/"//g')`
aws ec2 delete-subnet --subnet-id `(terraform output -json subnet_id2 | jq '.value[0]'| sed 's/"//g')`
aws ec2 delete-subnet --subnet-id `(terraform output -json subnet_id3 | jq '.value[0]'| sed 's/"//g')`

 aws ec2 delete-security-group --group-id `(terraform output security_group)`

sleep 30s
aws ec2 delete-vpc --vpc-id `(terraform output vpc_id | sed 's/"//g')`

echo "" > subnet1_instance_ids.txt
echo "" > subnet2_instance_ids.txt
echo "" > subnet3_instance_ids.txt
echo "" > subnet4_instance_ids.txt