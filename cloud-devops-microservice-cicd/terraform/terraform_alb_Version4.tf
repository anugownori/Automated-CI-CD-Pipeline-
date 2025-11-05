resource "aws_lb" "microservice" {
  name               = "cloud-devops-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = aws_subnet.public[*].id
}
resource "aws_lb_target_group" "microservice" {
  name     = "cloud-devops-target-group"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check { interval = 30; path = "/health"; protocol = "HTTP"; matcher = "200"; healthy_threshold = 2; unhealthy_threshold = 2 }
}
resource "aws_lb_listener" "microservice" {
  load_balancer_arn = aws_lb.microservice.arn
  port              = "80"
  protocol          = "HTTP"
  default_action { type = "forward"; target_group_arn = aws_lb_target_group.microservice.arn }
}
resource "aws_security_group" "alb" {
  vpc_id = aws_vpc.main.id
  description = "Allow HTTP inbound"
  ingress { from_port = 80; to_port = 80; protocol = "tcp"; cidr_blocks = ["0.0.0.0/0"] }
  egress  { from_port = 0; to_port = 0; protocol = "-1"; cidr_blocks = ["0.0.0.0/0"] }
}