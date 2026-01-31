locals {
  module_id = "${var.namespace}-${var.stage}-${var.name}"
}

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = merge(var.tags, { Name = local.module_id })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${local.module_id}-igw" })
}

# --- Public Subnets (Calculated Dynamically) ---
resource "aws_subnet" "public" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.this.id
  # Magic: takes /16 and adds 8 bits -> /24. Index ensures uniqueness.
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index) 
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, { 
    Name = "${local.module_id}-public-${element(split("-", var.availability_zones[count.index]), 2)}" 
    Tier = "Public"
  })
}

# --- Private Subnets ---
resource "aws_subnet" "private" {
  count             = length(var.availability_zones)
  vpc_id            = aws_vpc.this.id
  # Magic: Offset by 10 to avoid overlap (e.g., 10.0.10.0/24)
  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index + 10) 
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.tags, { 
    Name = "${local.module_id}-private-${element(split("-", var.availability_zones[count.index]), 2)}" 
    Tier = "Private"
  })
}

# ... (NAT Gateway & Route Tables logic here - standard but cleanly named) ...