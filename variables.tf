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