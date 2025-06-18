# 🚀 Strapi CMS Deployment on AWS ECS Fargate using Terraform & GitHub Actions

This project automates the deployment of a Strapi backend to **AWS ECS Fargate** using:

- 🐳 Docker (containerized build)
- ☁️ AWS ECS Fargate (serverless container service)
- 📦 Docker Hub (image hosting)
- 🔧 Terraform (infrastructure as code)
- 🤖 GitHub Actions (CI/CD pipeline)

---

## 📁 Project Structure

```
Repo/
├── .github/workflows/
│   └── deploy.yml          # CI/CD pipeline: Docker build, push & deploy via Terraform
├── docker/
│   └── Dockerfile          # Dockerfile for production Strapi build
├── terraform/
│   └── main.tf             # Terraform to provision ECS cluster, task, service & SG
├── Strapi-Aryan/
│   ├── package.json        # Strapi backend code
│   └── .dockerignore       # Docker ignore for build context
└── README.md
```

---

## ⚙️ Setup Instructions

### 🔐 1. Create GitHub Secrets

In your GitHub repository settings, add the following secrets:

| Secret Name              | Description                             |
|--------------------------|-----------------------------------------|
| `DOCKER_USERNAME`        | Your Docker Hub username                |
| `DOCKER_PASSWORD`        | Your Docker Hub password/token          |
| `DOCKER_REPO`            | Full repo name (e.g. `username/image`)  |
| `AWS_ACCESS_KEY_ID`      | IAM access key for AWS                  |
| `AWS_SECRET_ACCESS_KEY`  | IAM secret key for AWS                  |
| `AWS_REGION`             | AWS region (e.g. `us-east-1`)           |
| `HOST`                   | Strapi host (`0.0.0.0`)                 |
| `PORT`                   | Strapi port (`1337`)                    |
| `APP_KEYS`               | Strapi app keys                         |
| `API_TOKEN_SALT`         | Strapi API token salt                   |
| `ADMIN_JWT_SECRET`       | Strapi admin JWT secret                 |
| `TRANSFER_TOKEN_SALT`    | Strapi transfer token salt              |
| `JWT_SECRET`             | JWT secret                              |
| `ENCRYPTION_KEY`         | Strapi encryption key                   |

---

### 🚀 2. CI/CD Deployment Workflow

Each push to `main` will:

1. Build the Docker image from `Strapi-Aryan/`
2. Push to Docker Hub: `${{ secrets.DOCKER_REPO }}:latest`
3. Use Terraform to:
   - Provision a security group
   - Deploy ECS Fargate cluster, task, and service
   - Expose port 1337 to the internet

> 🌐 Result: Access your Strapi CMS at `http://<ECS-Public-IP>:1337`

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

✅ Output: ECS public IP where Strapi is running.

---

## 🧼 Cleanup

To destroy all AWS resources:

```bash
cd terraform
terraform destroy
```

---

## 🛠️ Notes

- ECS Fargate = zero EC2 hassle ✅
- All secrets are inject
