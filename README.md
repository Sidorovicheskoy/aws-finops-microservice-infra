# 🏦 FinOps Scalable Microservice Infrastructure

![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)
![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)

> **Enterprise-grade Infrastructure as Code (IaC) template designed for high-availability Fintech applications.**
> Features strict network isolation, automated security compliance, and a GitOps-based delivery pipeline.

---

## 🏗 Architecture Overview

This project provisions a secure, scalable container orchestration platform using **AWS ECS Fargate**. The architecture follows the **Well-Architected Framework**, prioritizing security (Zero Trust) and operational excellence.

```mermaid
graph TD
    User((Users)) -->|HTTPS| ALB[Application Load Balancer]
    subgraph VPC [VPC: eu-central-1]
        subgraph Public_Subnet [Public Subnets]
            ALB
            NAT[NAT Gateway]
        end
        subgraph Private_Subnet [Private Subnets]
            ECS[ECS Fargate Cluster]
            ECS -->|Pull Image| ECR[Amazon ECR]
            ECS -->|Logs| CW[CloudWatch]
        end
    end
    ALB -->|Traffic| ECS
    ECS -->|Outbound| NAT

## 🚀 Key Features
🛡️ Security First
Network Isolation: Compute resources (ECS Tasks) are deployed in Private Subnets with no direct internet access.

Identity Management: Uses OIDC (OpenID Connect) for GitHub Actions authentication (No long-lived AWS Access Keys).

Least Privilege: Custom IAM policies strictly scoped to required resources.

Compliance: Integrated tfsec scanning in the CI/CD pipeline to prevent misconfigurations.

☁️ Modern Compute & Networking
Serverless Containers: Powered by AWS Fargate to eliminate server management overhead.

Dynamic Networking: VPC subnets are calculated dynamically using cidrsubnet functions, ensuring scalability without address overlap.

Traffic Management: Application Load Balancer (ALB) with strict Security Group chaining.

⚙️ DevOps & Automation (GitOps)
Automated Delivery: Full CI/CD pipeline using GitHub Actions.

Pull Request Feedback: Terraform Plans are automatically commented on Pull Requests for peer review.

State Management: Remote S3 Backend with DynamoDB locking to prevent state corruption.

📂 Project Structure
The project follows a modular architecture inspired by Cloud Posse standards for reusability and context management.
.
├── .github/workflows   # CI/CD Pipelines (Plan & Apply)
├── modules/            # Reusable Terraform Modules
│   ├── network/        # VPC, Subnets, Gateways
│   ├── traffic/        # ALB, Target Groups, Security Groups
│   ├── compute/        # ECS Cluster, Fargate Services, Autoscaling
│   └── identity/       # IAM Roles & Policies
├── main.tf             # Root Orchestrator
├── variables.tf        # Global Configuration Inputs
└── locals.tf           # Naming Convention Logic
