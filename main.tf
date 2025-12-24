############################################
# IAM Password Policy
############################################
resource "aws_iam_account_password_policy" "strong_policy" {
  minimum_password_length        = 12
  require_uppercase_characters   = true
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true
  password_reuse_prevention      = 5
}

############################################
# IAM Groups (Department-wise)
############################################
resource "aws_iam_group" "groups" {
  for_each = var.department_policies

  name = "${lower(each.key)}-group"
}

############################################
# Attach Department Policies to Groups
############################################
resource "aws_iam_group_policy_attachment" "group_policy" {
  for_each = var.department_policies

  group      = aws_iam_group.groups[each.key].name
  policy_arn = each.value
}

############################################
# MFA Enforcement Policy
############################################
resource "aws_iam_policy" "enforce_mfa" {
  name = "enforce-mfa-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Deny"
      Action   = "*"
      Resource = "*"
      Condition = {
        BoolIfExists = {
          "aws:MultiFactorAuthPresent" = "false"
        }
      }
    }]
  })
}

############################################
# Attach MFA Policy to All Groups
############################################
resource "aws_iam_group_policy_attachment" "mfa_attach" {
  for_each = aws_iam_group.groups

  group      = each.value.name
  policy_arn = aws_iam_policy.enforce_mfa.arn
}

############################################
# IAM Users
############################################
resource "aws_iam_user" "users" {
  for_each = local.users_map

  name = each.value.username

  tags = {
    Email      = each.value.email
    Department = each.value.department
  }
}

############################################
# Login Profile (Force Password Reset)
############################################
resource "aws_iam_user_login_profile" "login" {
  for_each = local.users_map

  user                    = aws_iam_user.users[each.key].name
  password_reset_required = true
}

############################################
# Add Users to Groups
############################################
resource "aws_iam_user_group_membership" "user_group" {
  for_each = local.users_map

  user = aws_iam_user.users[each.key].name

  groups = [
    aws_iam_group.groups[lower(each.value.department)].name
  ]
}

############################################
# Virtual MFA Device (Creation Only)
############################################
resource "aws_iam_virtual_mfa_device" "mfa" {
  for_each = local.users_map

  virtual_mfa_device_name = "${each.key}-mfa"
}
