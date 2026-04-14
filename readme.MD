                                 Author:Ogaji Igwe Samuel
                                 GitHub:@samklin92
Cloud and DevOps Engineer focused on scalable infrastructure, automation, and continuous improvement | Open to Work
                   

# 🏦 terraform-eks-banking-app

> **Production-grade 3-Tier Banking Application deployed on AWS EKS using Terraform, GitOps and modern DevSecOps practices.**

![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-%23326CE5.svg?style=for-the-badge&logo=kubernetes&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)
![ArgoCD](https://img.shields.io/badge/Argo_CD-%23EF7B4D.svg?style=for-the-badge&logo=argo&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-%234479A1.svg?style=for-the-badge&logo=mysql&logoColor=white)
![Spring Boot](https://img.shields.io/badge/Spring_Boot-%236DB33F.svg?style=for-the-badge&logo=springboot&logoColor=white)
![React](https://img.shields.io/badge/React-%2361DAFB.svg?style=for-the-badge&logo=react&logoColor=black)
![Nginx](https://img.shields.io/badge/Nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)

---

## 📐 Architecture Overview

```
Internet
    │
    ▼
Internet Gateway
    │
    ▼
┌─────────────────────────────────────────────────────────────┐
│                    VPC  192.168.0.0/16                      │
│                                                             │
│  ┌─────────────────┐         ┌─────────────────┐           │
│  │  Public Subnet  │         │  Public Subnet  │           │
│  │  AZ us-east-1a  │         │  AZ us-east-1b  │           │
│  │  192.168.0.0/24 │         │  192.168.1.0/24 │           │
│  │  + NAT Gateway  │         │  + NAT Gateway  │           │
│  └────────┬────────┘         └────────┬────────┘           │
│           │    External NLB           │                     │
│           └───────────┬───────────────┘                     │
│                       │                                     │
│              EKS Control Plane                              │
│                       │                                     │
│  ┌─────────────────┐  │  ┌─────────────────┐               │
│  │ Private Subnet  │  │  │ Private Subnet  │               │
│  │  AZ us-east-1a  │  │  │  AZ us-east-1b  │               │
│  │  192.168.3.0/24 │  │  │  192.168.4.0/24 │               │
│  │  Worker Node 0X │  │  │  Worker Node 0Y │               │
│  │  (t3.medium)    │  │  │  (t3.medium)    │               │
│  └─────────────────┘  │  └─────────────────┘               │
│           │    Internal NLB           │                     │
│           └───────────┬───────────────┘                     │
│                       │                                     │
│  ┌─────────────────┐     ┌─────────────────┐               │
│  │  DB Subnet 01   │     │  DB Subnet 02   │               │
│  │  192.168.5.0/24 │     │  192.168.6.0/24 │               │
│  │  RDS MySQL      │     │  RDS MySQL      │               │
│  │  (Primary)      │     │  (Standby)      │               │
│  └─────────────────┘     └─────────────────┘               │
└─────────────────────────────────────────────────────────────┘
          │
          ▼
    Route 53 (samklin.online)
          │
    ┌─────┴──────┐
    │            │
nginx-controller  cert-manager
    │            │
    └─────┬──────┘
          │
    ┌─────┴──────────────┐
    │                    │
 bank.samklin.online  bankapi.samklin.online
 (React Frontend)     (Spring Boot API)
```

---

## 🗂️ Repository Structure

```
terraform-eks-banking-app/
├── .github/
│   └── workflows/
│       └── cicd.yaml              # GitHub Actions CI/CD pipeline
├── bootstrap/                     # Remote state backend (run once)
│   ├── main.tf                    # S3 bucket + DynamoDB lock table
│   ├── provider.tf
│   └── output.tf
├── module-vpc/                    # VPC, subnets, NAT gateways, routing
│   ├── 02-vpc.tf
│   ├── 03-igt.tf
│   ├── 04-public_subnet.tf
│   ├── 05-private_subnets.tf
│   ├── 06-elp.tf
│   ├── 07-nat-gateway.tf
│   ├── 08-private-route-table.tf
│   ├── 09-public-route-table.tf
│   ├── 10-public-route-associate.tf
│   ├── 11-private-route-associate.tf
│   ├── 12-private-subnet-db.tf
│   ├── 13-mysql-sg.tf
│   ├── output.tf
│   └── variables.tf
├── module-eks/                    # EKS cluster, node groups, Helm releases
│   ├── addons.tf                  # nginx, cert-manager, Argo CD
│   ├── ecr.tf                     # ECR repositories
│   ├── eks-cluster.tf             # EKS cluster + KMS encryption
│   ├── iam.tf                     # IAM roles and policies
│   ├── output.tf
│   ├── variables.tf
│   ├── nginx-ingress-values.yaml
│   └── argocd-values.yaml
├── module-database/               # RDS MySQL with encryption
│   ├── rds.tf
│   ├── output.tf
│   └── variables.tf
├── module-dns/                    # Route53 hosted zone + DNS records
│   ├── route53.tf
│   ├── output.tf
│   └── variables.tf
├── ClusterIssuer.yaml             # Let's Encrypt cluster issuer
├── ingress-argocd.yaml            # Argo CD ingress rule
├── argocd-banking-app.yaml        # Argo CD application manifest
├── 01-provider.tf                 # AWS + Helm + Kubernetes providers
├── backend.tf                     # S3 remote state configuration
├── main.tf                        # Root module wiring
├── output.tf                      # Infrastructure outputs
├── variable.tf                    # Variable definitions
└── terraform.tfvars               # Variable values (gitignored)
```

---

## 🛠️ Tech Stack

| Layer | Technology | Purpose |
|---|---|---|
| ![IaC](https://img.shields.io/badge/IaC-Terraform_v1.6+-5835CC?style=flat-square&logo=terraform) | Terraform | Infrastructure as Code |
| ![Cloud](https://img.shields.io/badge/Cloud-AWS-FF9900?style=flat-square&logo=amazon-aws) | AWS | Cloud provider |
| ![Container](https://img.shields.io/badge/Container-EKS_v1.32-326CE5?style=flat-square&logo=kubernetes) | Amazon EKS | Managed Kubernetes |
| ![Runtime](https://img.shields.io/badge/Runtime-Docker-0db7ed?style=flat-square&logo=docker) | Docker | Container runtime |
| ![GitOps](https://img.shields.io/badge/GitOps-Argo_CD_v7-EF7B4D?style=flat-square&logo=argo) | Argo CD | GitOps deployment |
| ![CI/CD](https://img.shields.io/badge/CI/CD-GitHub_Actions-2671E5?style=flat-square&logo=githubactions) | GitHub Actions | CI/CD pipeline |
| ![Ingress](https://img.shields.io/badge/Ingress-nginx_controller-009639?style=flat-square&logo=nginx) | nginx-ingress | Kubernetes ingress |
| ![TLS](https://img.shields.io/badge/TLS-cert--manager_+_Let's_Encrypt-003A70?style=flat-square) | cert-manager | Automated TLS |
| ![DNS](https://img.shields.io/badge/DNS-Route_53-FF9900?style=flat-square&logo=amazon-aws) | Route 53 | DNS management |
| ![DB](https://img.shields.io/badge/DB-RDS_MySQL_8.0-4479A1?style=flat-square&logo=mysql) | Amazon RDS | Managed database |
| ![Encryption](https://img.shields.io/badge/Encryption-AWS_KMS-FF9900?style=flat-square&logo=amazon-aws) | AWS KMS | Key management |
| ![Registry](https://img.shields.io/badge/Registry-ECR-FF9900?style=flat-square&logo=amazon-aws) | Amazon ECR | Container registry |
| ![State](https://img.shields.io/badge/State-S3_+_DynamoDB-FF9900?style=flat-square&logo=amazon-aws) | S3 + DynamoDB | Remote state + locking |
| ![Frontend](https://img.shields.io/badge/Frontend-React_+_nginx-61DAFB?style=flat-square&logo=react) | React + nginx | Frontend application |
| ![Backend](https://img.shields.io/badge/Backend-Spring_Boot_3.1-6DB33F?style=flat-square&logo=springboot) | Spring Boot | Backend API |

---

## 🔐 Security Features

### Network Security
- ✅ **VPC isolation** — 3-tier subnet architecture (public / private / database)
- ✅ **No public RDS access** — database subnets have no internet route
- ✅ **NAT Gateways** — worker nodes egress-only, never directly exposed
- ✅ **Security groups** — MySQL port 3306 restricted to VPC CIDR only
- ✅ **EKS private endpoint** — control plane accessible from within VPC

### Encryption
- ✅ **RDS encryption at rest** — AES-256 via dedicated KMS key
- ✅ **EKS secrets encryption** — Kubernetes secrets encrypted with KMS
- ✅ **ECR image encryption** — KMS encrypted container images
- ✅ **TLS in transit** — Let's Encrypt certificates via cert-manager
- ✅ **S3 state encryption** — SSE-AES256 on Terraform state bucket

### IAM & Access Control
- ✅ **Least privilege IAM** — separate roles for EKS cluster and node groups
- ✅ **No hardcoded credentials** — all secrets via GitHub Actions secrets
- ✅ **SSM access** — node access via SSM, no SSH keys needed
- ✅ **Production environment** — manual approval required before apply/destroy

### Data Protection
- ✅ **RDS Multi-AZ** — synchronous replication across 2 AZs
- ✅ **Automated backups** — 7-day retention with point-in-time recovery
- ✅ **Deletion protection** — RDS cannot be accidentally deleted
- ✅ **Final snapshot** — snapshot taken before any RDS deletion
- ✅ **ECR immutable tags** — container images cannot be overwritten

---

## 🚀 Deployment Guide

### Prerequisites

```bash
# Required tools
terraform >= 1.6.0
aws-cli >= 2.x
kubectl >= 1.28
helm >= 3.x
docker >= 24.x
git
```

### Step 1 — Bootstrap Remote State (run once)

```bash
cd bootstrap/
terraform init
terraform apply
# Copy the output bucket name into backend.tf
```

### Step 2 — Configure GitHub Actions Secrets

Add these secrets to your GitHub repository:

| Secret | Description |
|---|---|
| `AWS_ACCESS_KEY_ID` | IAM user access key |
| `AWS_SECRET_ACCESS_KEY` | IAM user secret key |
| `AWS_REGION` | Target region (us-east-1) |
| `TF_VAR_DB_USERNAME` | RDS master username |
| `TF_VAR_DB_PASSWORD` | RDS master password (min 16 chars) |
| `TF_VAR_DB_NAME` | Database name |
| `TF_VAR_ZONE_NAME` | Your domain (e.g. example.com) |
| `TF_VAR_DOMAIN_NAME` | App domain (e.g. example.com) |
| `TF_VAR_EMAIL` | Email for TLS certificates |

### Step 3 — Deploy Infrastructure

```bash
# Clone the repo
git clone https://github.com/samklin92/terraform-eks-banking-app.git
cd terraform-eks-banking-app

# Initialise
terraform init

# Preview changes
terraform plan

# Deploy (triggers GitHub Actions with manual approval)
git push origin main
```

### Step 4 — Configure kubectl

```bash
aws eks update-kubeconfig \
  --name production-eks-cluster \
  --region us-east-1
kubectl get nodes
```

### Step 5 — Apply ClusterIssuer for TLS

```bash
kubectl apply -f ClusterIssuer.yaml
kubectl get clusterissuer
```

### Step 6 — Deploy Application via Argo CD

```bash
# Access Argo CD
kubectl port-forward svc/argocd-server -n argocd 8080:80

# Get admin password
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath='{.data.password}' | base64 -d

# Deploy application
kubectl apply -f argocd-banking-app.yaml
```

### Step 7 — Update DNS

Get nameservers from Terraform output:
```bash
terraform output route53_name_servers
```
Point your domain's nameservers to the 4 Route 53 nameservers.

---

## 🏗️ Infrastructure Details

### VPC Configuration

| Subnet | CIDR | AZ | Purpose |
|---|---|---|---|
| public-subnet-01 | 192.168.0.0/24 | us-east-1a | NAT Gateway, NLB |
| public-subnet-02 | 192.168.1.0/24 | us-east-1b | NAT Gateway, NLB |
| private-subnet-01 | 192.168.3.0/24 | us-east-1a | EKS Worker Nodes |
| private-subnet-02 | 192.168.4.0/24 | us-east-1b | EKS Worker Nodes |
| private-db-subnet-01 | 192.168.5.0/24 | us-east-1a | RDS Primary |
| private-db-subnet-02 | 192.168.6.0/24 | us-east-1b | RDS Standby |

### EKS Node Group

| Setting | Value |
|---|---|
| Instance type | t3.medium |
| Min size | 2 |
| Desired size | 2 |
| Max size | 6 |
| Capacity type | ON_DEMAND |
| Kubernetes version | 1.32 |

### RDS Configuration

| Setting | Value |
|---|---|
| Engine | MySQL 8.0 |
| Instance class | db.t3.micro |
| Storage | 20GB gp3 |
| Multi-AZ | Enabled |
| Encrypted | Yes (KMS) |
| Backup retention | 7 days |
| Deletion protection | Enabled |

---

## 🔄 CI/CD Pipeline

```
Push to main branch
        │
        ▼
┌───────────────────┐
│  Security Scan    │  tfsec static analysis
│  (tfsec)          │
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│  Terraform Plan   │  Preview infrastructure changes
│                   │  Upload plan artifact
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│  Manual Approval  │  Required reviewer must approve
│  (production env) │  before any apply or destroy
└────────┬──────────┘
         │
         ▼
┌───────────────────┐
│  Terraform Apply  │  Deploy infrastructure
│                   │  Configure EKS + kubectl
│                   │  Apply ClusterIssuer
│                   │  Apply Argo CD ingress
└───────────────────┘
```

---

## 🌐 Application URLs

| Service | URL |
|---|---|
| Frontend | https://bank.samklin.online |
| Backend API | https://bankapi.samklin.online |
| Argo CD | kubectl port-forward (internal only) |

---

## 🧹 Teardown

```bash
# Step 1 — Disable RDS deletion protection
aws rds modify-db-instance \
  --db-instance-identifier production-mysql-db \
  --no-deletion-protection \
  --apply-immediately \
  --region us-east-1

# Step 2 — Empty ECR repositories
aws ecr batch-delete-image \
  --repository-name bank-backendapi \
  --image-ids imageTag=v3 --region us-east-1

aws ecr batch-delete-image \
  --repository-name bank-frontend \
  --image-ids imageTag=v3 --region us-east-1

# Step 3 — Destroy all infrastructure
terraform destroy

# Step 4 — Destroy bootstrap (optional)
cd bootstrap/
aws s3 rm s3://banking-app-tfstate-ACCOUNTID --recursive
terraform destroy
```

---

## 📁 Related Repositories

| Repo | Purpose |
|---|---|
| [Bank-App-Backend](https://github.com/samklin92/Bank-App-Backend) | Spring Boot API |
| [Bank-App-Frontend](https://github.com/samklin92/Bank-App-Frontend) | React Frontend |
| [kubernetes-manifest](https://github.com/samklin92/kubernetes-manifest) | K8s manifests (Argo CD source) |

---

## 👤 Author

**samklin92**
Built with ❤️ as a production-grade DevOps portfolio project.

---

## 📄 License

MIT License — free to use, modify and distribute with attribution.
