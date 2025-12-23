# AWS IAM User Migration & MFA Automation using Terraform

> **Role:** Cloud Specialist  
> **Project Type:** Cloud Automation | IAM Security | Infrastructure as Code  
> **Tools:** AWS IAM, Terraform, AWS CLI, Git Bash, CSV  

---

## 🚀 Project Overview

In this project, based on a **real-world enterprise scenario**, I acted as a **Cloud Specialist** with the mission to **migrate IAM users in an automated, secure, and scalable way**.

The organization needed to migrate **100 IAM users** and ensure that **Multi-Factor Authentication (MFA)** was enabled for every account, as this is a critical AWS security best practice.

Performing this task manually through the AWS Console would be inefficient, error-prone, and unscalable. To solve this, I designed and implemented a **fully automated IAM onboarding solution** using **Terraform and AWS IAM**, following real enterprise security standards.

---

## 🎯 Problem Statement

- 100 users required onboarding  
- Manual IAM creation does not scale  
- MFA enforcement was mandatory  
- Permissions had to follow least-privilege principles  
- The solution needed to be repeatable and auditable  

---

## 🛠️ Solution Approach

The solution uses a **CSV-driven automation model**, where user data acts as the single source of truth.

```
users.csv → Terraform → AWS IAM
```

### Workflow
1. User data is defined in `users.csv`
2. Terraform parses and validates the CSV
3. IAM users are created automatically
4. Users are assigned to department-based IAM groups
5. Least-privilege policies are attached to groups
6. MFA enforcement policy blocks access unless MFA is enabled

---

## 🏗️ Solution Architecture

The architecture below represents an **on‑premises to AWS IAM migration scenario**, where users are securely onboarded into AWS with enforced MFA and controlled permissions.

![Solution Architecture](screenshots/Solution-Architecture.jpg)

### Architecture Explanation
- Users originate from an **on‑premises corporate environment**
- IAM users are created in **AWS IAM**
- Users are assigned to **IAM groups** based on department
- **Permissions** are granted through group-based policies
- **MFA tokens** are enforced before AWS access is allowed

---

## 📁 Project Structure

```
iam-user-automation/
├── users.csv
├── providers.tf
├── variables.tf
├── locals.tf
├── main.tf
├── .gitignore
├── CONTRIBUTING.md
└── README.md
```

---

## 📄 users.csv Format

```csv
username,email,department
krishna.dev,krishna.dev@company.com,Development
vikas.test,vikas.test@company.com,Testing
deepak.dba,deepak.dba@company.com,DBA
prashanth.ops,prashanth.ops@company.com,DevOps
```

### CSV Rules
- `username` must be unique
- `department` must be one of Development, Testing, DBA, DevOps

---

## 🔐 IAM Design

| Department   | IAM Group         | Policy Attached        |
|-------------|-------------------|------------------------|
| Development | development-group | AmazonS3FullAccess     |
| Testing     | testing-group     | AmazonS3ReadOnlyAccess |
| DBA         | dba-group         | AmazonRDSFullAccess    |
| DevOps      | devops-group      | AdministratorAccess    |

---

## ⚙️ Key Features

- CSV-driven IAM onboarding  
- Automated IAM user creation  
- Department-based group access  
- Least-privilege permissions  
- MFA enforcement for all users  
- Scales to 1000+ users  

---

## 🚀 How to Run

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

---

## 🧠 What I Learned

- IAM automation at enterprise scale
- MFA enforcement strategies
- Terraform for security use cases
- Group-based IAM design
- Designing secure cloud architectures

---

## 🧹 Cleanup

```bash
terraform destroy
```

---

## 👤 Author

**Prashanth S**  
Cloud | DevOps | IAM Automation

## Connect with Me

📌 GitHub: [Your Repository URL](https://github.com/prashanths125)
📌 LinkedIn: [www.linkedin.com/in/sprashanthclouddevopsai](https://www.linkedin.com/in/sprashanthclouddevopsai/)
