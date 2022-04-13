variable access_key         {}
variable secret_key         {}
variable region             {}
variable vpc_id             {}
variable subnet_id          {}
variable showName           {}
variable instance_size      {}
variable os                 {}

locals {
    instance_type = var.instance_size == "small" ? "t3.small" : var.instance_size == "medium" ? "t3.medium" : var.instance_size == "large" ? "t3.large" : "t2.micro"
    ami = var.os == "server2019" ? data.aws_ami.latest_amazon_windows_2019.id : var.os == "ubuntu" ? data.aws_ami.latest_ubuntu.id : data.aws_ami.latest_ubuntu.id
 }
