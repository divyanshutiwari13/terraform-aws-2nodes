# Next.js Project Deployment using Terraform on AWS

This project demonstrates the **automated deployment** of a dummy **Next.js** project on **two Ubuntu 24.04 EC2 instances** using **Terraform**. It includes setting up Node.js, PM2 process manager, Nginx reverse proxy, and SSL certificates via Certbot.

---

## Project Overview

- **Terraform**: Automates infrastructure creation and configuration.
- **EC2 Instances**: Two Ubuntu 24.04 machines.
- **Node.js**: Installed via NVM (Node Version Manager).
- **PM2**: Runs the Next.js application as a background process.
- **Nginx**: Configured as a reverse proxy to forward requests to the Node.js app.
- **Certbot SSL**: Automatically applies SSL certificates and sets up auto-renewal.
- **GitHub Integration**: Pulls the Next.js project using a Personal Access Token (PAT).

---

## Folder Structure

```
terraform-aws-2nodes/
│
├─ main.tf               # Terraform main configuration
├─ variables.tf          # Terraform variables definition
├─ terraform.tfvars      # Values for the variables
├─ deploy_script.sh      # User data script to deploy the app on EC2
├─ README.md             # Project documentation
```

---

## Pre-requisites

- **AWS Account** with IAM user and programmatic access.
- **Terraform installed** locally.
- **GitHub repository** with the Next.js project.
- **SSH key pair** in AWS to access EC2 instances.

---

## Setup Instructions

1. **Configure variables in `terraform.tfvars`:**

```hcl
aws_region          = "ap-south-1"
ssh_key_name        = "terraform-key"
github_repo         = "your-github-username/your-repo"
github_pat          = "your_github_pat_here"
instance_type       = "t2.micro"
root_volume_size_gb = 8
ssl_email           = "youremail@example.com"
```

2. **Initialize Terraform**
```bash
terraform init
```

3. **Validate Terraform Configuration**
```bash
terraform validate
```

4. **Apply Terraform to create resources and deploy app**
```bash
terraform apply -auto-approve
```

5. **Check output**

Terraform will output the public IPs of both EC2 instances. Use these IPs to configure your DNS 
node1.divyanshutiwari.site , node2.divyanshutiwari.site 

6. **Deployment Log**

After deployment, the logs can be checked at:
```
/home/ubuntu/deploy.log
```

Example log content:

**Node1:**
```
===== Starting deployment for node1.divyanshutiwari.site =====
System updated and dependencies installed.
Node.js and PM2 configured successfully.
Application cloned from GitHub and started with PM2.
Nginx configured and SSL applied successfully.
===== Deployment complete for node1.divyanshutiwari.site =====
```

**Node2:**
```
===== Starting deployment for node2.divyanshutiwari.site =====
System updated and dependencies installed.
Node.js and PM2 configured successfully.
Application cloned from GitHub and started with PM2.
Nginx configured and SSL applied successfully.
===== Deployment complete for node2.divyanshutiwari.site =====
```


