# --- Context ---
variable "namespace" { type = string }
variable "stage"     { type = string }
variable "name"      { type = string }
variable "tags"      { type = map(string) }

# --- Network & Security ---
variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of Private Subnet IDs for Fargate Tasks"
}

variable "security_groups" {
  type        = list(string)
  description = "List of Security Group IDs to attach to the ECS Task"
}

# --- Load Balancing ---
variable "target_group_arn" {
  type        = string
  description = "ARN of the ALB Target Group"
}

# --- IAM ---
variable "execution_role_arn" {
  type        = string
  description = "ARN of the ECS Task Execution Role"
}

# --- App Specs ---
variable "container_image" {
  type        = string
  description = "Docker image to deploy"
}

variable "container_port" {
  type        = number
  description = "Port exposed by the container"
}

variable "cpu" {
  type        = number
  description = "Fargate CPU units"
}

variable "memory" {
  type        = number
  description = "Fargate Memory units"
}