output "address" {
  value = ["${aws_instance.VM0.*.public_dns}"]
}

output "address1" {
  value = ["${aws_instance.VM1.*.public_dns}"]
}

output "address2" {
  value = ["${aws_instance.VM2.*.public_dns}"]
}

output "instance_id" {
	value = ["${aws_instance.VM0.*.id}"]
}

output "instance_id1" {
	value = ["${aws_instance.VM1.*.id}"]
}

output "instance_id2" {
	value = ["${aws_instance.VM2.*.id}"]
}

output "instance_id3" {
	value = ["${aws_instance.VM3.*.id}"]
}

output "gateway_id" {
	value = "${aws_internet_gateway.igw.id}"
}
output "subnet_id" {
	value = ["${aws_subnet.terraform_subnet.id}"]
}

output "subnet_id1" {
	value = ["${aws_subnet.terraform_subnet1.id}"]
}

output "subnet_id2" {
	value = ["${aws_subnet.terraform_subnet2.id}"]
}

output "subnet_id3" {
	value = ["${aws_subnet.terraform_subnet3.id}"]
}

output "lb" {
	value = "${aws_elb.lb.name}"
}

output "security_group" {
	value = "${aws_security_group.security_group_terraform.id}"
}

output "vpc_id" {
	value = "${aws_vpc.main_vpc.id}"
}

output "route_table_id" {
	value = "${aws_vpc.main_vpc.main_route_table_id}"
}