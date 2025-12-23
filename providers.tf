# --------------------------------------------------
# Terraform and AWS Provider Configuration
# --------------------------------------------------
# This block defines the minimum Terraform version
# and the AWS provider required for this project.
# Pinning versions ensures predictable behavior
# across environments.
# --------------------------------------------------

terraform {
  required_version = ">= 1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# --------------------------------------------------
# AWS Provider
# --------------------------------------------------
# Region is configurable and can be overridden
# via environment variables or tfvars if needed.
# --------------------------------------------------

provider "aws" {
  region = var.aws_region
}