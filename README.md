# GCP Infrastructure Setup with Terraform

This repository includes Terraform configurations for creating a VPC and subnets on GCP.

## Prerequisites

- Google Cloud SDK configured with appropriate permissions
- Terraform installed

## Quick Start

1. **Initialize Terraform**

   terraform init

2. **Create or update infrastructure**
   
   terraform apply

3. **Destroy infrastructure**
   
   terraform destroy


## Configurations

- VPC webapp-vpc without auto-created subnetworks
- webapp subnet with CIDR 10.0.1.0/24
- db subnet with CIDR 10.0.2.0/24
- Internet gateway route
- Firewall rules to allow web traffic and deny SSH access from the internet.
- A VM instance within the webapp subnet, pre-configured for your web applications.

## Deployement

To deploy your infrastructure:

- Configure your Terraform variables as needed.
- Run terraform apply to create your infrastructure.
- Once the infrastructure is set up, you can deploy your web applications on the VM instance.