packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.1"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "amazon_linux" {
  ami_name      = "jenkins-ami"
  instance_type = "t2.micro"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-kernel-5.10-hvm-2.0.20220207.1-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["137112412989"]
  }

  subnet_filter {
    filters = {
      "tag:Class": "build"
    }
    most_free = true
    random = false
  }

  ssh_username = "ec2-user"
}

build {
  name = "jenkins-ami"
  sources = [
    "source.amazon-ebs.amazon_linux"
  ]

  provisioner "ansible" {
    playbook_file = "./scripts/setup_jenkins_ami.yaml"
  }
}