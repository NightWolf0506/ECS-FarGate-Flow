provider "aws" {
  region = "us-east-1"



}

# Use default VPC
data "aws_vpc" "default" {
  default = true
}

# Use default subnets in that VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Security Group in default VPC
resource "aws_security_group" "strapi_sg2" {
  name   = "strapi-sg2"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 1337
    to_port     = 1337
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "strapi_cluster2" {
  name = "strapi-cluster2"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "strapi_task2" {
  family                   = "strapi-task2"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "3072"

  execution_role_arn       = "arn:aws:iam::607700977843:role/ecsTaskExecutionRole" # Replace with your valid IAM role ARN

  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = "nightwolf0506/strapi-app:latest"
      essential = true
      portMappings = [
        {
          containerPort = 1337
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "strapi_service2" {
  name            = "strapi-service2"
  cluster         = aws_ecs_cluster.strapi_cluster2.id
  task_definition = aws_ecs_task_definition.strapi_task2.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    assign_public_ip = true
    security_groups  = [aws_security_group.strapi_sg2.id]
  }
}

# Output Public IP Instruction
output "note" {
  value = "Go to AWS Console → ECS → Task → Networking tab to get the public IP."
}
