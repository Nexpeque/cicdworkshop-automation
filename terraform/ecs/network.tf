resource "aws_security_group" "allow_ssh_ecs" {
  name        = "allow_ssh_ecs"
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

resource "aws_security_group_rule" "ecs_http_8080" {
  type              = "ingress"
  from_port         = 0
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_ssh_ecs.id
}

resource "aws_security_group_rule" "ecs_http" {
  type              = "ingress"
  from_port         = 0
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_ssh_ecs.id
}