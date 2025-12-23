# --------------------------------------------------
# AWS Region
# --------------------------------------------------
# Defines the AWS region where IAM resources
# will be created.
# --------------------------------------------------
variable "aws_region" {
  description = "AWS region for IAM resource creation"
  type        = string
  default     = "us-east-1"
}

# --------------------------------------------------
# CSV File Path
# --------------------------------------------------
# Path to the CSV file that acts as the single
# source of truth for IAM user onboarding.
# --------------------------------------------------
variable "users_csv_path" {
  description = "Path to CSV file containing IAM users"
  type        = string
  default     = "users.csv"
}

# --------------------------------------------------
# Force Destroy IAM Users
# --------------------------------------------------
# Allows Terraform to delete IAM users even if
# they still have credentials attached.
# Useful for clean teardown in test environments.
# --------------------------------------------------
variable "force_destroy" {
  description = "Force destroy IAM users on terraform destroy"
  type        = bool
  default     = true
}