output "address" {
  value = ["${aws_instance.terraform_example.*.public_dns}"]
}

output "address1" {
  value = ["${aws_instance.terraform_example1.*.public_dns}"]
}

output "instance_id" {
	value = ["${aws_instance.terraform_example.*.id}"]
}

output "instance_id1" {
	value = ["${aws_instance.terraform_example1.*.id}"]
}

output "gateway_id" {
	value = "${aws_internet_gateway.igw.id}"
}
output "subnet_id" {
	value = ["${aws_instance.terraform_example.*.subnet_id}"]
}

output "subnet_id1" {
	value = ["${aws_instance.terraform_example1.*.subnet_id}"]
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