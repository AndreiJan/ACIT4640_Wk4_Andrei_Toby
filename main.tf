# Configure version of AWS provider plugin
# https://developer.hashicorp.com/terraform/language/terraform#terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Define local values
# https://developer.hashicorp.com/terraform/language/values/locals
locals {
  project_name = "lab_week_4"
}

# Get the most recent AMI for Debian
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
data "aws_ami" "debian" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["debian-*-amd64-*"]
  }
}

# Create a VPC
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
resource "aws_vpc" "web" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name    = "project_vpc"
    Project = local.project_name
  }
}

# Create a public subnet
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
# To use the free tier t2.micro EC2 instance, you must declare an AZ
# Some AZs do not support this instance type
resource "aws_subnet" "web" {
  vpc_id                  = aws_vpc.web.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-west-2a"
  map_public_ip_on_launch = true

  tags = {
    Name    = "Web"
    Project = local.project_name
  }
}

# Create internet gateway for VPC
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
resource "aws_internet_gateway" "web-gw" {
  vpc_id = aws_vpc.web.id

  tags = {
    Name    = "Web"
    Project = local.project_name
  }
}

# Create route table for web VPC 
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
resource "aws_route_table" "web" {
  vpc_id = aws_vpc.web.id

  tags = {
    Name    = "web-route"
    Project = local.project_name
  }
}

# Add default route to route table
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.web.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.web-gw.id
}

# Associate route table with subnet
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association
resource "aws_route_table_association" "web" {
  subnet_id      = aws_subnet.web.id
  route_table_id = aws_route_table.web.id
}

# Create security group
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "web" {
  name        = "allow_ssh"
  description = "Allow SSH from home and work"
  vpc_id      = aws_vpc.web.id

  tags = {
    Name    = "Web"
    Project = local.project_name
  }
}

# Allow SSH ingress
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule
resource "aws_vpc_security_group_ingress_rule" "web-ssh" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

# Allow HTTP ingress
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule
resource "aws_vpc_security_group_ingress_rule" "web-http" {
  security_group_id = aws_security_group.web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

# Allow all outbound traffic
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule
resource