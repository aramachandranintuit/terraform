provider "aws" {
	region ="us-east-1"
}

data "aws_availability_zones" "available" {}

resource "random_id" "server" {
  byte_length = 8
}

resource "aws_vpc" "main_vpc" {
	cidr_block = "${var.vpcCidr}"
	enable_dns_support   = true
    enable_dns_hostnames = true
    tags {
		Name = "vpc-${random_id.server.hex}"
	}
}

resource "aws_route" "internetroute" {
	route_table_id = "${aws_vpc.main_vpc.main_route_table_id}"
	destination_cidr_block = "0.0.0.0/0"
	gateway_id = "${aws_internet_gateway.igw.id}"
	
}

resource "aws_internet_gateway" "igw" {
	vpc_id = "${aws_vpc.main_vpc.id}"
}

resource "aws_subnet" "terraform_subnet" {
	vpc_id = "${aws_vpc.main_vpc.id}"
	availability_zone = "${data.aws_availability_zones.available.names[0]}"
	cidr_block = "${var.subnet1Cidr}"
}

resource "aws_subnet" "terraform_subnet1" {
	vpc_id = "${aws_vpc.main_vpc.id}"
	availability_zone = "${data.aws_availability_zones.available.names[0]}"
	cidr_block = "${var.subnet2Cidr}"
}

resource "aws_subnet" "terraform_subnet2" {
	vpc_id = "${aws_vpc.main_vpc.id}"
	availability_zone = "${data.aws_availability_zones.available.names[1]}"
	cidr_block = "${var.subnet3Cidr}"
}

resource "aws_subnet" "terraform_subnet3" {
	vpc_id = "${aws_vpc.main_vpc.id}"
	availability_zone = "${data.aws_availability_zones.available.names[1]}"
	cidr_block = "${var.subnet4Cidr}"
}


resource "aws_elb" "lb" {
  name = "Infra-setup-lb"
  subnets = ["${aws_subnet.terraform_subnet1.id}","${aws_subnet.terraform_subnet3.id}"]
  security_groups = ["${aws_security_group.security_group_terraform.id}"]
  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }


  instances                   = ["${aws_instance.VM1.*.id}","${aws_instance.VM3.*.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

}


resource "aws_instance" "VM0" {
	count = 240
    ami = "${var.AMI}"
    availability_zone = "${data.aws_availability_zones.available.names[0]}"
    instance_type = "t2.micro"
	key_name = "code_deploy_app"
	vpc_security_group_ids=["${aws_security_group.security_group_terraform.id}"]
	subnet_id ="${aws_subnet.terraform_subnet.id}"
	associate_public_ip_address = true
	tags {
		Name = "linuxWS${count.index}"
	}

	timeouts {
    create = "60m"
    delete = "2h"
  }
}

resource "aws_instance" "VM1" {
	count = 240
    ami = "${var.WordPressAMI}"
    availability_zone = "${data.aws_availability_zones.available.names[0]}"
    instance_type = "t2.micro"
	key_name = "code_deploy_app"
	vpc_security_group_ids=["${aws_security_group.security_group_terraform.id}"]
	subnet_id ="${aws_subnet.terraform_subnet1.id}"
	associate_public_ip_address = true
	tags {
		Name = "WordPress-${count.index}"
	}

	timeouts {
    create = "60m"
    delete = "2h"
  }
}

resource "aws_instance" "VM2" {
	count = 240
    ami = "${var.LinuxAppAMI}"
    availability_zone = "${data.aws_availability_zones.available.names[1]}"
    instance_type = "t2.micro"
	key_name = "code_deploy_app"
	vpc_security_group_ids=["${aws_security_group.security_group_terraform.id}"]
	subnet_id ="${aws_subnet.terraform_subnet2.id}"
	associate_public_ip_address = true
	tags {
		Name = "LinuxApp-${count.index}"
	}

	timeouts {
    create = "60m"
    delete = "2h"
  }
}


resource "aws_instance" "VM3" {
	count = 240
    ami = "${var.WordPressAMI}"
    availability_zone = "${data.aws_availability_zones.available.names[1]}"
    instance_type = "t2.micro"
	key_name = "code_deploy_app"
	vpc_security_group_ids=["${aws_security_group.security_group_terraform.id}"]
	subnet_id ="${aws_subnet.terraform_subnet3.id}"
	associate_public_ip_address = true
	tags {
		Name = "myWordPressAMI-${count.index}"
	}

	timeouts {
    create = "60m"
    delete = "2h"
  }
}



resource "aws_security_group" "security_group_terraform" {
	vpc_id = "${aws_vpc.main_vpc.id}"
	ingress {
		from_port = 0
		to_port = 0
		protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
	}

	ingress {
		from_port = 0
		to_port = 0
		protocol = "-1"
        ipv6_cidr_blocks = ["::/0"]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
	}

	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
        ipv6_cidr_blocks = ["::/0"]
	}
}
