variable server_port {
	default = 8080
}


variable AMI {
	default = "ami-043f5cbbf75c48676"
}

variable vpcCidr {
	default = "11.1.0.0/16"
}

variable subnet1Cidr {
	default  = "11.1.1.0/24"
}

variable subnet2Cidr {
	default  = "11.1.2.0/24"
}

variable subnet3Cidr {
	default  = "11.1.3.0/24"
}

variable subnet4Cidr {
	default  = "11.1.4.0/24"
}

variable WordPressAMI {
	default = "ami-0da9ce4bc048d3e84"
}

variable LinuxAppAMI {
	default = "ami-01b01f6ed6ccbac3a"
}
