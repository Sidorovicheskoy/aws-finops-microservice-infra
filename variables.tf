variable "aws_region" {
  type        = string
  description = "AWS Region for the infrastructure deployment (e.g., eu-central-1)."
  default     = "eu-central-1"
}

# --- Context Variables ---
variable "enabled" {
  type        = bool
  description = "Set to false to prevent the module from creating any resources."
  default     = true
}

variable "namespace" {
  type        = string
  description = "Organization name (e.g., 'corp' or 'finops')."
  default     = "finops"
}

variable "stage" {
  type        = string
  description = "Environment stage (e.g., 'dev', 'staging', 'prod')."
  default     = "dev"
}

variable "name" {
  type        = string
  description = "Application or solution name (e.g., 'transaction-processor')."
  default     = "core-platform"
}

variable "tags" {
  type        = map(string)
  description = "Additional tags (e.g., `{'BusinessUnit': 'XYZ'}`)."
  default     = {}
}

# --- Network Configuration ---
variable "vpc_cidr_block" {
  type        = string
  description = "CIDR block for the main VPC."
  default     = "172.16.0.0/16"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of Availability Zones to deploy resources into."
  default     = ["eu-central-1a", "eu-central-1b"]
}

# --- Application Configuration ---
variable "container_image" {
  type        = string
  description = "Docker image to deploy (including tag)."
  default     = "nginx:alpine" # Placeholder
}

variable "container_port" {
  type        = number
  description = "Port exposed by the docker container."
  default     = 80
}

variable "fargate_cpu" {
  type        = number
  description = "Fargate instance CPU units (1 vCPU = 1024)."
  default     = 512
}

variable "fargate_memory" {
  type        = number
  description = "Fargate instance Memory (in MiB)."
  default     = 1024
}