# ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "daveyork-dev-ecs-cluster"
}

# IAM Role for Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecution-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Task Definition
resource "aws_ecs_task_definition" "task" {
  family                   = "my-task"
  
  runtime_platform {
    cpu_architecture         = "ARM64"
    operating_system_family  = "LINUX"
  }

  network_mode             = "awsvpc"  # Required for Fargate tasks
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"     # 0.25 vCPU
  memory                   = "512"     # 512 MB RAM
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "app",
      image     = "588965866330.dkr.ecr.us-east-2.amazonaws.com/medos/dev:latest",
      essential = true,
      portMappings = [
        {
          containerPort = 3000,
          hostPort      = 3000,
          protocol      = "tcp"
        }
      ]
    }
  ])
}

#############################################
# ECS Service
#############################################
resource "aws_ecs_service" "service" {
  name            = "daveyork-dev-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = var.security_group_ids
    assign_public_ip = true
  }
}
