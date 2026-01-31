# --- Context ---
variable "namespace" { type = string }
variable "stage"     { type = string }
variable "name"      { type = string }
variable "tags"      { type = map(string) }

# --- Network Inputs ---
variable "vpc_id" {
  type        = string
  description = "VPC ID where the ALB and Security Groups will be created"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of Public Subnet IDs for the Load Balancer"
}

# --- App Config ---
variable "container_port" {
  type        = number
  description = "Port on which the container is listening (for Target Group)"
}