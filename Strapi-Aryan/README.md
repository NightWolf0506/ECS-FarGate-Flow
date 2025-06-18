# 🚀 Task 5 – Deploy Strapi on EC2 using Docker & Terraform

1. 🐳 Build your Strapi Docker image:
   docker build -t task5 .

2. 🏷️ Tag & push to Docker Hub:
   docker tag task5 yourusername/strapi-app:latest
   docker push yourusername/strapi-app:latest

3. 🧱 Write Terraform (main.tf) to:
   - Launch EC2 (Ubuntu)
   - Install Docker (via user_data)
   - Pull your image from Docker Hub
   - Run the container on port 80

4. 🟢 Deploy with Terraform:
   terraform init  
   terraform apply

5. 🌐 Access your Strapi app on:  
   http://<your-ec2-public-ip>

💡 Tip: To avoid AWS charges, run `terraform destroy` when you're done.
