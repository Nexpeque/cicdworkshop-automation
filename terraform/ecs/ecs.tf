resource "aws_ecs_task_definition" "definition" {
  family                   = var.family
  container_definitions    = local.definition
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "1024"
  requires_compatibilities = ["FARGATE"]
}

resource "aws_ecs_service" "service_dns" {
  name            = var.image_name
  cluster         = aws_ecs_cluster.cluster.name
  task_definition = aws_ecs_task_definition.definition.arn
  desired_count   = var.desired_count

  lifecycle {
    create_before_destroy = true
  }
  network_configuration {
    subnets = [data.aws_subnet.subnet.id]
    assign_public_ip = true
    security_groups = [aws_security_group.allow_ssh_ecs.id]
  }

  launch_type = var.launch_type
  depends_on  = [aws_ecs_task_definition.definition]
}


locals {
  image = "${var.image_url}:${var.image_version}"
  definition = templatefile("./definitions/container-definition.json.tpl", {
    name           = var.image_name
    image          = local.image
    container_port = var.container_port
  })
}