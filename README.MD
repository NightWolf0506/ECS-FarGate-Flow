# 🚀 Strapi CMS Deployment on AWS EC2 using Terraform & GitHub Actions

This project automates the deployment of a Strapi backend using:

- 🐳 Docker (containerized build)
- ☁️ AWS EC2 (Ubuntu 22.04)
- 📦 Docker Hub (image hosting)
- 🔧 Terraform (infrastructure as code)
- 🤖 GitHub Actions (CI/CD pipeline)

---

## 📁 Project Structure

```
Repo/
├── .github/workflows/
│   └── deploy.yml          # CI/CD pipeline: Docker build, push & deploy
├── docker/
│   └── Dockerfile          # Dockerfile for production Strapi build
├── terraform/
│   └── main.tf             # Terraform to provision EC2 & deploy container
├── Strapi-Aryan/
│   ├── package.json        # Strapi backend code
│   └── .dockerignore       # Docker ignore for build context
└── README.md
```

---

## ⚙️ Setup Instructions

### 🔐 1. Create GitHub Secrets

In your GitHub repository settings, add the following secrets:

| Secret Name              | Description                       |
|--------------------------|-----------------------------------|
| `DOCKER_USERNAME`        | Your Docker Hub username          |
| `DOCKER_PASSWORD`        | Your Docker Hub password/token    |
| `AWS_ACCESS_KEY_ID`      | IAM access key for AWS            |
| `AWS_SECRET_ACCESS_KEY`  | IAM secret key for AWS            |
| `AWS_REGION`             | AWS region (e.g. `us-east-1`)     |

---

### 🏗️ 2. Deployment Workflow

Each push to `main` (or manual trigger) will:

1. Build the Docker image using `Strapi-Aryan/`
2. Push the image to Docker Hub: `nightwolf0506/strapi-app:latest`
3. Use Terraform to:
   - Provision an EC2 instance
   - Install Docker and run the container on port 1337

> 🌐 Result: Access your Strapi backend at `http://<EC2-IP>:1337`

---

## 📦 Docker (Local Build & Run)

```bash
docker build -f docker/Dockerfile -t strapi-app ./Strapi-Aryan
docker run -p 1337:1337 strapi-app
```

---

## 🌍 Terraform (Manual Deploy)

```bash
cd terraform
terraform init
terraform apply
```

✅ Output: EC2 public IP where Strapi is running.

---

## 🧼 Cleanup

```bash
cd terraform
terraform destroy
```

---


