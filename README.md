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