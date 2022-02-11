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

resource "aws_ecs_cluster" "cluster" {
  name = "cicd-workshop"
}

data "aws_subnet" "subnet" {
  filter {
    name   = "tag:Name"
    values = ["Build"]
  }
}

