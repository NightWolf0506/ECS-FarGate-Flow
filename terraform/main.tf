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
resource "aws_security_group" "strapi_sg1" {
  name   = "strapi-sg1"
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

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "strapi_logs" {
  name              = "/ecs/strapi"
  retention_in_days = 7
}

# ECS Cluster
resource "aws_ecs_cluster" "strapi_cluster1" {
  name = "strapi-cluster1"
}

# Task Definition
resource "aws_ecs_task_definition" "strapi_task1" {
  family                   = "strapi-task1"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "3072"
  execution_role_arn       = "arn:aws:iam::607700977843:role/ecsTaskExecutionRole" # Use existing IAM role


  container_definitions = jsonencode([
    {
      name      = "strapi"
      image     = "nightwolf0506/strapi-app:latest"
      essential = true
       portMappings = [{
      containerPort = 1337
      protocol      = "tcp"
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.strapi_logs.name
        awslogs-region        = "us-east-1"
        awslogs-stream-prefix = "ecs"
      }
    }
    }
  ])
}

# ECS Service
resource "aws_ecs_service" "strapi_service1" {
  name            = "strapi-service1"
  cluster         = aws_ecs_cluster.strapi_cluster1.id
  task_definition = aws_ecs_task_definition.strapi_task1.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    assign_public_ip = true
    security_groups  = [aws_security_group.strapi_sg1.id]
  }
}



# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "strapi_dashboard" {
  dashboard_name = "strapi-ecs-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric",
        x = 0, y = 0, width = 12, height = 6,
        properties = {
          title = "CPU Utilization",
          view = "timeSeries",
          metrics = [
            [ "AWS/ECS", "CPUUtilization", "ClusterName", aws_ecs_cluster.strapi_cluster1.name, "ServiceName", aws_ecs_service.strapi_service1.name ]
          ],
          region = "us-east-1",
          stat = "Average",
          period = 300
        }
      },
      {
        type = "metric",
        x = 12, y = 0, width = 12, height = 6,
        properties = {
          title = "Memory Utilization",
          view = "timeSeries",
          metrics = [
            [ "AWS/ECS", "MemoryUtilization", "ClusterName", aws_ecs_cluster.strapi_cluster1.name, "ServiceName", aws_ecs_service.strapi_service1.name ]
          ],
          region = "us-east-1",
          stat = "Average",
          period = 300
        }
      }
    ]
  })
}

# CloudWatch Alarm for High CPU
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "HighCPUUtilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 300
  statistic           = "Average"
  threshold           = 75
  alarm_description   = "This alarm triggers when CPU exceeds 75%"
  dimensions = {
    ClusterName = aws_ecs_cluster.strapi_cluster1.name
    ServiceName = aws_ecs_service.strapi_service1.name
  }
}

# Output for IP instruction
output "note" {
  value = "Go to AWS Console → ECS → Task → Networking tab to get the public IP."
}
