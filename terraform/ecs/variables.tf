variable "image_name" {
  type    = string
  default = "cicdworkshop"
}

variable "image_url" {
  type    = string
  default = "436054236749.dkr.ecr.us-east-1.amazonaws.com/cicdworkshop"
}

variable "image_version" {
  type    = string
  default = "latest"
}

variable "family" {
  type    = string
  default = "cicd-definition"
}

variable "desired_count" {
  type    = number
  default = 1
}

variable "container_port" {
  type    = number
  default = 80
}

variable "launch_type" {
  type    = string
  default = "FARGATE"
}

