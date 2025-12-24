# ------------------------------------------------------------------
# CSV User Data Parsing & Normalization
# ------------------------------------------------------------------
locals {
  users = csvdecode(file(var.csv_file_path))

  users_map = {
    for user in local.users :
    user.username => user
  }
}
