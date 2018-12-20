provider "aws" {
	region ="us-east-1"
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "main_vpc" {
	cidr_block = "11.1.0.0/16"
	enable_dns_support   = true
    enable_dns_hostnames = true
	tags {
		Name = "terraform_vpc" 
	}
}

resource "aws_route" "internetroute" {
	route_table_id = "${aws_vpc.main_vpc.main_route_table_id}"
	destination_cidr_block = "0.0.0.0/0"
	gateway_id = "${aws_internet_gateway.igw.id}"
	
}

resource "aws_internet_gateway" "igw" {
	vpc_id = "${aws_vpc.main_vpc.id}"
	tags {
		Name = "t_gateway"
	}
}

resource "aws_subnet" "terraform_subnet" {
	vpc_id = "${aws_vpc.main_vpc.id}"
	availability_zone = "${data.aws_availability_zones.available.names[0]}"
	cidr_block = "11.1.1.0/24"
	tags {
		Name = "perf"
	}
}

resource "aws_subnet" "terraform_subnet1" {
	vpc_id = "${aws_vpc.main_vpc.id}"
	availability_zone = "${data.aws_availability_zones.available.names[1]}"
	cidr_block = "11.1.2.0/24"
	tags {
		Name = "perf"
	}
}


resource "aws_instance" "terraform_example" {
	count = 200
    ami = "${var.AMI}"
    availability_zone = "${data.aws_availability_zones.available.names[0]}"
    instance_type = "t2.micro"
	key_name = "code_deploy_app"
	vpc_security_group_ids=["${aws_security_group.security_group_terraform.id}"]
	subnet_id ="${aws_subnet.terraform_subnet.id}"
	associate_public_ip_address = true
	tags {
		Name = "perf"
	}

	timeouts {
    create = "60m"
    delete = "2h"
  }
}

resource "aws_instance" "terraform_example1" {
	count = 210
    ami = "${var.AMI}"
    availability_zone = "${data.aws_availability_zones.available.names[1]}"
    instance_type = "t2.micro"
	key_name = "code_deploy_app"
	vpc_security_group_ids=["${aws_security_group.security_group_terraform.id}"]
	subnet_id ="${aws_subnet.terraform_subnet1.id}"
	associate_public_ip_address = true
	tags {
		Name = "perf"
	}

	timeouts {
    create = "60m"
    delete = "2h"
  }
}


resource "aws_security_group" "security_group_terraform" {
	name = "terraform_security_group"
	vpc_id = "${aws_vpc.main_vpc.id}"
	ingress {
		from_port = 0
		to_port = 0
		protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
	}
}
