# DATA SOURCE

data "aws_availability_zones" "available" {
  state = "available"
}

# RESOURCES

# NETWORKING

module "app" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  cidr = var.vpc_cidr_block

  azs = slice(data.aws_availability_zones.available.names, 0, var.vpc_public_subnet_count)
  #slice extracts some consecutive elements from within a list (slice(list, startindex, endindex),startindex is inclusive, while endindex is exclusive)

  # Assumes 8 bits to be added to the CIDR range for the VPC
  public_subnets  = [for subnet in range(var.vpc_public_subnet_count) : cidrsubnet(var.vpc_public_subnets_cidr_block, 8, subnet)]
  private_subnets = [for subnet in range(var.vpc_private_subnet_count) : cidrsubnet(var.vpc_private_subnets_cidr_block, 8, subnet)]

  enable_nat_gateway      = true
  enable_vpn_gateway      = false
  map_public_ip_on_launch = var.map_public_ip_on_launch
  enable_dns_hostnames    = var.enable_dns_hostnames

  tags = merge(local.common_tags, {
    Name = "${local.naming_prefix}-vpc"
  })
}

# SECURITY GROUPS

resource "aws_security_group" "nginx_sg" {
  name       = "${local.naming_prefix}-nginx_sg"
  vpc_id     = module.app.vpc_id
  depends_on = [aws_security_group.alb_sg]

  # HTTP access from ALB SG
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # allow ALB SG
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # allow ALB SG
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}



resource "aws_security_group" "alb_sg" {
  name   = "${local.naming_prefix}-nginx_alb_sg"
  vpc_id = module.app.vpc_id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}



resource "aws_security_group" "rds_sg" {
  name   = "${local.naming_prefix}-rds_sg"
  vpc_id = module.app.vpc_id

  # HTTP access from anywhere
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [module.app.private_subnets.cidr_blocks]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags

}
