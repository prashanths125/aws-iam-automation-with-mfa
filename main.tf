# --------------------------------------------------
# IAM User Creation
# --------------------------------------------------
resource "aws_iam_user" "users" {
  for_each = { for user in local.validated_users : user.username => user }

  name          = each.value.username
  force_destroy = var.force_destroy

  tags = {
    Department = each.value.department
    ManagedBy  = "Terraform"
    Project    = "IAM-User-Automation"
  }
}

# --------------------------------------------------
# IAM Groups (Department-Based)
# --------------------------------------------------
resource "aws_iam_group" "department_groups" {
  for_each = { for dept in local.allowed_departments : lower(dept) => dept }

  name = "${each.key}-group"
  # Tags are NOT supported here
}

# --------------------------------------------------
# User → Group Mapping
# --------------------------------------------------
resource "aws_iam_user_group_membership" "membership" {
  for_each = aws_iam_user.users

  user = each.value.name
  groups = [
    aws_iam_group.department_groups[lower(local.validated_users[each.key].department)].name
  ]
}

# --------------------------------------------------
# MFA Enforcement Policy
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
resource "aws_iam_group_policy_attachment" "mfa_attach" {
  for_each = aws_iam_group.department_groups

  group      = each.value.name
  policy_arn = aws_iam_policy.mfa_enforcement.arn
}

# --------------------------------------------------
# Attach Department-Specific Policies
# --------------------------------------------------
resource "aws_iam_group_policy_attachment" "department_policy_attach" {
  for_each = aws_iam_group.department_groups

  group      = each.value.name
  policy_arn = var.department_policies[each.key]
}
