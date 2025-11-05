resource "aws_ecs_cluster" "main" { name = "cloud-devops-ecs-cluster" }
resource "aws_ecs_task_definition" "microservice" {
  family                   = "cloud-devops-task-def"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_exec.arn
  container_definitions = jsonencode([
    {
      name      = "cloud-devops-microservice"
      image     = "${aws_ecr_repository.microservice.repository_url}:${var.image_tag}"
      essential = true
      portMappings = [{ containerPort = 3000, protocol = "tcp" }]
      logConfiguration = { logDriver = "awslogs", options = { "awslogs-group" = "/ecs/cloud-devops-microservice", "awslogs-region" = var.aws_region, "awslogs-stream-prefix" = "ecs" } }
    }
  ])
}
resource "aws_ecs_service" "microservice" {
  name            = "cloud-devops-microservice-svc"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.microservice.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.alb.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.microservice.arn
    container_name   = "cloud-devops-microservice"
    container_port   = 3000
  }
  depends_on = [aws_lb_listener.microservice]
}