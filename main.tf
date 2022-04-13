provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "random_id" "uid" {
  byte_length = 4
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "this" {
  key_name   = "snowpov-keypair-${random_id.uid.hex}"
  public_key = tls_private_key.this.public_key_openssh
}

resource "aws_security_group" "this" {
  name        = "snowpov-sg-${random_id.uid.hex}"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.os == "server2019" ? 3389 : var.os == "ubuntu" ? 22 : 22
    to_port     = var.os == "server2019" ? 3389 : var.os == "ubuntu" ? 22 : 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  tags = {
    Name = "snowpov"
  }
}

resource "aws_instance" "this" {
  count                   = 1
  ami                     = local.ami
  disable_api_termination = false
  instance_type           = local.instance_type
  key_name                = "vinhawslinuxcred"
  vpc_security_group_ids  = [aws_security_group.this.id]
  monitoring              = false
  subnet_id               = var.subnet_id
  iam_instance_profile    = "default_instance_profile-us-east-1-3ojf6j59vv9hh5bb"

  tags = {
    Name = "snowpov"
  }
}

