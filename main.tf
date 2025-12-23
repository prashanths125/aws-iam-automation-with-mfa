# --------------------------------------------------
# IAM User Creation
# --------------------------------------------------
# Creates IAM users dynamically based on CSV input.
# Each user is uniquely identified by username.
# --------------------------------------------------

resource "aws_iam_user" "users" {
  for_each = {
    for user in local.validated_users :
    user.username => user
  }

  name          = each.value.username
  force_destroy = var.force_destroy

  # ------------------------------------------------
  # Resource Tags
  # ------------------------------------------------
  # Tags help with auditing, cost tracking,
  # and enterprise governance.
  # ------------------------------------------------
  tags = {
    Department = each.value.department
    ManagedBy  = "Terraform"
    Project    = "IAM-User-Automation"
  }
}

# --------------------------------------------------
# IAM Groups (Department-Based)
# --------------------------------------------------
# Groups are created per department to enforce
# least-privilege access using policies.
# --------------------------------------------------

resource "aws_iam_group" "department_groups" {
  for_each = toset(local.allowed_departments)

  name = lower(each.key) + "-group"
}

# --------------------------------------------------
# User → Group Mapping
# --------------------------------------------------
# Automatically assigns users to their
# respective department groups.
# --------------------------------------------------

resource "aws_iam_user_group_membership" "membership" {
  for_each = aws_iam_user.users

  user   = each.value.name
  groups = [
    aws_iam_group.department_groups[each.value.tags.Department].name
  ]
}

# --------------------------------------------------
# MFA Enforcement Policy
# --------------------------------------------------
# This policy DENIES all actions unless the user
# has authenticated using MFA.
#
# ⚠️ AWS does NOT allow full automation of MFA
# activation. Users must complete MFA setup
# manually by scanning a QR code.
# --------------------------------------------------

resource "aws_iam_policy" "mfa_enforcement" {
  name        = "enforce-mfa-policy"
  description = "Deny access unless MFA is enabled"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Deny"
        Action   = "*"
        Resource = "*"
        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent" = "false"
          }
        }
      }
    ]
  })
}

# --------------------------------------------------
# Attach MFA Policy to All Groups
# --------------------------------------------------
# Ensures MFA enforcement applies consistently
# across all departments.
# --------------------------------------------------

resource "aws_iam_group_policy_attachment" "mfa_attach" {
  for_each = aws_iam_group.department_groups

  group      = each.value.name
  policy_arn = aws_iam_policy.mfa_enforcement.arn
}