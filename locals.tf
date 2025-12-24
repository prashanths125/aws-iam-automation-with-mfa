# --------------------------------------------------
# Parse CSV File
# --------------------------------------------------
# Reads the users.csv file and converts it into
# a structured list of users.
# Normalization (lowercase, trim, title-case)
# prevents data quality issues.
# --------------------------------------------------

locals {
  users = [
    for user in csvdecode(file(var.users_csv_path)) : {
      username   = lower(trim(user.username, " "))
      email      = lower(trim(user.email, " "))
      department = title(trim(user.department, " "))
    }
  ]

  # ------------------------------------------------
  # Allowed Departments
  # ------------------------------------------------
  # This list acts as a validation layer to ensure
  # only approved departments are processed.
  # ------------------------------------------------
  allowed_departments = [
    "Development",
    "Testing",
    "DBA",
    "DevOps"
  ]

  # ------------------------------------------------
  # Validated Users
  # ------------------------------------------------
  # Filters out users with invalid departments.
  # Prevents Terraform failures and enforces
  # controlled onboarding.
  # ------------------------------------------------
  validated_users_list = [
    for u in local.users : u
    if contains(local.allowed_departments, u.department)
  ]

  # Convert list to map keyed by username
  validated_users = {
    for u in local.validated_users_list : u.username => u
  }
}
