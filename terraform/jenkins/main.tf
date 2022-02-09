terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.27"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_subnet" "subnet" {
  filter {
    name   = "tag:Name"
    values = ["Build"]
  }
}

data "aws_ami" "jenkins_ami" {
  most_recent = true
  filter {
    name   = "name"
    values = ["jenkins-ami"]
  }

  owners = ["self"]
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "jenkins-keypair"
  public_key = tls_private_key.pk.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.pk.private_key_pem}' > ./myKey.pem"
  }
}

resource "aws_security_group" "allow_ssh_jenkins" {
  name        = "allow_ssh_jenkins"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_subnet.subnet.vpc_id

  ingress {
    description      = "SSH from world VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["190.70.41.65/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_security_group_rule" "jenkins_http" {
  type              = "ingress"
  from_port         = 0
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_ssh_jenkins.id
}

resource "aws_instance" "jenkins_server" {
  ami           = data.aws_ami.jenkins_ami.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.kp.key_name
  subnet_id     = data.aws_subnet.subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_jenkins.id]
  tags = {
    Name = "JenkinsServer"
  }
}