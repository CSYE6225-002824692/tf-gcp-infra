# variables.tf

variable "region" {
  description = "The region where the resources will be created"
  type        = string
  default     = "us-east1"
}

variable "vpc_name" {
  description = "The name of the VPC to be created"
  type        = string
}

variable "project" {
  description = "The GCP project ID."
}

variable "webapp_subnet_cidr" {
  description = "CIDR block for the webapp subnet."
  default     = "10.0.1.0/24"
}

variable "db_subnet_cidr" {
  description = "CIDR block for the database subnet."
  default     = "10.0.2.0/24"
}

variable "routing_mode" {
  description = "The network routing mode (REGIONAL or GLOBAL)."
  default     = "REGIONAL"
}

variable "webapp_subnet_name" {
  default = "webapp"
}

variable "db_subnet_name" {
  default = "db"
}

variable "webapp_port" {
  default = "8080"
}
variable "instance_name" {

}

variable "machine_type" {
  default = "e2-medium"
}

variable "zone" {
  default = "us-east1-b"
}

variable "boot_disk_image" {

}
variable "boot_disk_type" {
  default = "pd-balanced"
}
variable "boot_disk_size" {
  default = 100
}

variable "service_account_scopes" {

}

variable "firewall_allow_source_ranges" {

}

variable "firewall_deny_source_ranges" {

}

variable "protocol" {

}

variable "ssh_port" {

}

variable "vm_network_tier" {
  default = "PREMIUM"
}

variable "cloud_sql_instance_name" {
  description = "The name of the Cloud SQL instance"
  type        = string
}


# Update the default to MySQL 8
variable "database_version" {
  description = "The database version to use."
  type        = string
  default     = "MYSQL_8_0"
}

variable "startup_script_path" {
  type    = string
  default = "./startup_script.sh"
}

variable "tags" {
  description = "The tags to apply to the resources."
  type        = list(string)
  default     = ["web", "application"]
}

variable "webapp_user" {
  description = "The username for the webapp database user."
  type        = string
  default = "webapp"
  
}

variable "webapp_db_name" {
  description = "The name of the webapp database."
  type        = string
  default     = "webapp"
}

variable "override_special" {
  type        = string
  default     = "!#$%&*()-_=+[]{}<>:?"
}

variable "availability_type_db" {
  description = "The availability type for the Cloud SQL instance."
  type        = string
  default     = "REGIONAL"
}

variable "deletion_protection_enabled" {
  description = "Whether deletion protection is enabled for the Cloud SQL instance."
  type        = bool
  default     = false
}

variable "disk_size_db" {
  description = "The size of the disk for the Cloud SQL instance."
  type        = number
  default     = 100
}

variable "disk_type_db" {
  description = "The type of disk for the Cloud SQL instance."
  type        = string
  default     = "PD_SSD"
}

variable "ipv4_enabled_db" {
  description = "Whether the Cloud SQL instance has a public IP address."
  type        = bool
  default     = false
  
}

variable "binary_log_enabled_db" {
  description = "Whether binary logging is enabled for the Cloud SQL instance."
  type        = bool
  default     = true
  
}

variable "backup_configuration_enabled" {
  description = "Whether automated backups are enabled for the Cloud SQL instance."
  type        = bool
  default     = true
  
}

variable "disk_autoresize_db" {
  description = "Whether the disk for the Cloud SQL instance is automatically resized."
  type        = bool
  default     = true
  
}

variable "activation_policy_db" {
  description = "The activation policy for the Cloud SQL instance."
  type        = string
  default     = "ALWAYS"
}

variable "tier_db" {
  description = "The machine type for the Cloud SQL instance."
  type        = string
  default     = "db-f1-micro"
  
}

variable "service_networking_connection" {
  description = "The name of the service networking connection."
  type        = string
  default     = "servicenetworking.googleapis.com"
}

variable "purpose_private_services_range" {
  description = "The purpose of the private services range."
  type        = string
  default     = "VPC_PEERING"
  
}

variable "address_type_private_services_range" {
  description = "The address type of the private services range."
  type        = string
  default     = "INTERNAL"
  
}

variable "address_private_services_range" {
  description = "The address of the private services range."
  type        = string
  default     = "10.0.3.0"
}

variable "prefix_length_private_services_range" {
  description = "The prefix length of the private services range."
  type        = number
  default     = 24
}

variable "next_hop_gateway" {
  description = "The next hop gateway for the route."
  type        = string
  default     = "default-internet-gateway"
  
}

variable "dest_range_webapp_internet_route" {
  description = "The destination range for the webapp internet route."
  type        = string
  default     = "0.0.0.0/0"
  
}