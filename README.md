# GCP Infrastructure Setup with Terraform

This repository contains Terraform configurations for setting up a comprehensive infrastructure on Google Cloud Platform (GCP). It includes configurations for creating a Virtual Private Cloud (VPC), subnets, a Cloud SQL database, firewall rules, service accounts, and a VM instance pre-configured for web applications.

## Prerequisites

- Google Cloud SDK configured with appropriate permissions
- Terraform installed

## Quick Start

1. **Initialize Terraform**

   Run the Terraform initialization command to prepare your working directory for other commands.

   ```bash
   terraform init

2. **Create or update infrastructure**
   
   Apply the Terraform configurations to create or update your infrastructure as defined in the .tf files.
   
   ```bash
   terraform init

3. **Destroy infrastructure**
   
   Remove all the Terraform-managed infrastructure.

   ```bash
   terraform destroy


## Configurations

The Terraform scripts will set up the following components in GCP environment:

- VPC: A Virtual Private Cloud named webapp-vpc without auto-created subnetworks for enhanced control over network architecture.
- Subnets: Two subnets within the VPC:
- A webapp subnet designed for web application servers.
- A db subnet dedicated to database services.
- Internet Gateway Route: A route that allows outbound internet access for resources in the VPC.
- Firewall Rules: Configurations to allow web traffic to the webapp subnet and deny SSH access from the internet for added security.
- Cloud SQL Database: A MySQL database instance for application data storage, fully managed by GCP.
- Service Accounts: Custom service accounts with specific roles for logging and monitoring, ensuring minimal privileges for security.
- VM Instance: A Google Compute Engine instance within the webapp subnet, pre-configured for hosting web applications. It also includes metadata for database connectivity and a startup script for initial setup.
- DNS Configuration: A DNS A record set up for the VM instance, facilitating domain name resolution.


## Deployment

To deploy your infrastructure with these Terraform scripts:

1. **Configure Terraform Variables**: Update the `terraform.tfvars` file or set appropriate environment variables to match your GCP project details and desired configuration.
   
2. **Run Terraform Apply**: Execute the `terraform apply` command to create or update your infrastructure according to the defined configurations. Review the plan and confirm the changes to proceed.
   
3. **Deploy Web Applications**: Once the infrastructure is set up, you can deploy your web applications on the configured VM instance. Use the VM's metadata for database connection details.