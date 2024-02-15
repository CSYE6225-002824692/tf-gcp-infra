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
