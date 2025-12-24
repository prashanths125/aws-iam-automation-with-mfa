# Contributing Guidelines

Thank you for your interest in contributing to this project.

## Prerequisites
- Terraform >= 1.3
- AWS CLI configured
- IAM permissions to manage users and groups

## Development Workflow
1. Fork the repository
2. Create a feature branch
3. Run `terraform fmt -recursive`
4. Run `terraform validate`
5. Submit a pull request with a clear description

## Code Standards
- Follow Terraform best practices
- Use meaningful resource names
- Add comments for complex logic
- Never hardcode credentials

## Security
- Do not commit Terraform state files
- Do not store passwords or secrets
