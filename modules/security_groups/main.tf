variable "vpc_id"   { type = string }
variable "app_port" { type = number }

resource "aws_security_group" "alb" {
  name   = "alb-sg"
  vpc_id = var.vpc_id

  ingress {
    description = "Allow HTTP from world"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "alb-sg" }
}

resource "aws_security_group" "ec2" {
  name   = "ec2-app-sg"
  vpc_id = var.vpc_id

  ingress {
    description     = "App traffic from ALB"
    from_port       = var.app_port
    to_port         = var.app_port
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "ec2-app-sg" }
}

output "alb_sg_id" { value = aws_security_group.alb.id }
output "ec2_sg_id" { value = aws_security_group.ec2.id }
