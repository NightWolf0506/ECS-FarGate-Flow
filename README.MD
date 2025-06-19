# 🚀 Strapi CMS Deployment on AWS ECS Fargate using Terraform & GitHub Actions

This project automates deployment of a **Strapi CMS** to **AWS ECS Fargate**, including monitoring and cleanup, using:

- 🐳 Docker (for containerization)
- ☁️ AWS ECS Fargate (serverless containers)
- 📦 Docker Hub (for image storage)
- 🔧 Terraform (to provision infrastructure)
- 🤖 GitHub Actions (CI/CD with auto-destroy)

---

## 📁 Project Structure

```
Repo/
├── .github/workflows/
│   └── deploy.yml          # GitHub Actions: Docker build + Terraform apply & destroy
├── docker/
│   └── Dockerfile          # Strapi Dockerfile for production
├── terraform/
│   └── main.tf             # Terraform: ECS, log group, alarms, etc.
├── Strapi-Aryan/
│   ├── package.json        # Strapi backend project
│   └── .dockerignore
└── README.md
```

---

## ⚙️ Setup Instructions

### 🔐 1. Add GitHub Secrets

Go to your GitHub repo → **Settings** → **Secrets and Variables** → **Actions**, then add:

| Secret Name              | Description                             |
|--------------------------|-----------------------------------------|
| `DOCKER_USERNAME`        | Docker Hub username                     |
| `DOCKER_PASSWORD`        | Docker Hub password or access token     |
| `DOCKER_REPO`            | Docker repo (e.g. `yourname/strapi-app`)|
| `AWS_ACCESS_KEY_ID`      | AWS IAM access key                      |
| `AWS_SECRET_ACCESS_KEY`  | AWS IAM secret key                      |
| `AWS_REGION`             | e.g. `us-east-1`                        |
| `HOST`                   | Strapi host (`0.0.0.0`)                 |
| `PORT`                   | Strapi port (`1337`)                    |
| `APP_KEYS`               | Strapi app keys                         |
| `API_TOKEN_SALT`         | Strapi API token salt                   |
| `ADMIN_JWT_SECRET`       | Admin JWT secret                        |
| `TRANSFER_TOKEN_SALT`    | Transfer token salt                     |
| `JWT_SECRET`             | JWT secret                              |
| `ENCRYPTION_KEY`         | Encryption key                          |

---

## 🚀 2. GitHub Actions CI/CD Workflow

On push to `main`, the workflow will:

1. ✅ Build Docker image from `Strapi-Aryan/`
2. ✅ Push image to Docker Hub
3. ✅ Deploy AWS infrastructure via Terraform:
   - ECS Cluster, Fargate Task, Service
   - Security Group (port 1337)
   - CloudWatch Log Group
   - Dashboard (CPU + Memory)
   - Alarm for CPU > 75%
4. ⏳ Wait 10 minutes
5. 💣 **Auto-destroy** all provisioned resources

🟢 Result: Strapi backend runs temporarily for testing, then cleans up.

---

## 📦 Local Docker Testing

```bash
docker build -f docker/Dockerfile -t strapi-app ./Strapi-Aryan
docker run -p 1337:1337 strapi-app
```

---

## 🌍 Manual Terraform Usage

```bash
cd terraform
terraform init
terraform apply -auto-approve
```

🟢 After deploy:  
Check ECS → Tasks → Networking tab → copy public IP.  
Visit `http://<ip>:1337` to access Strapi.

---

## 📊 CloudWatch Monitoring

Deployed automatically:

- **Dashboard**:
  - CPU Utilization
  - Memory Utilization
- **Alarm**:
  - CPU > 75% for 10 minutes → triggers alarm

---

## 🧼 Auto Cleanup

After 10 minutes, the GitHub Actions pipeline **automatically runs**:

```bash
terraform destroy -auto-approve
```

To manually destroy:

```bash
cd terraform
terraform destroy -auto-approve
```

---

## 🛠 Notes

- ECS Fargate = no EC2, no servers to manage
- Metrics (CPU/Memory) appear in ~5 minutes after task starts
- Logs are in CloudWatch Log Group: `/ecs/strapi`
- Public IP is ephemeral — session lasts 10 minutes only
- Ideal for testing, demos, CI environments

---

## 👨‍💻 Author

Deployed & automated by **Aryan**  
CI/CD, ECS, Docker, and Terraform – done right ✅
