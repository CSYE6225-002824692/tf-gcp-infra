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
  default     = false
  
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

variable "vm_service_account" {
  description = "The service account to use for the VM."
  type        = string
  default     = "vm-service-account"
}

variable "vm_service_account_display_name" {
  description = "The display name for the VM service account."
  type        = string
  default     = "VM Service Account"
  
}

variable "logging_admin_role" {
  description = "The role to grant to the logging service account."
  type        = string
  default     = "roles/logging.admin"
  
}

variable "monitoring_metric_writer_role" {
  description = "The role to grant to the monitoring service account."
  type        = string
  default     = "roles/monitoring.metricWriter"
  
}

variable "existing_dns_managed_zone" {
  description = "The name of the existing DNS managed zone."
  type        = string
  default     = "csye-webapp-zone"
  
}

variable "vm_a_record_name" {
  description = "The name of the A record for the VM."
  type        = string
  default     = "csyewebapp.me."
  
}

variable "vm_a_record_type" {
  description = "The type of the A record for the VM."
  type        = string
  default     = "A"
  
}

variable "vm_a_record_ttl" {
  description = "The TTL of the A record for the VM."
  type        = number
  default     = 300
  
}

variable "pubsub_topic_name" {
  description = "The name of the Pub/Sub topic."
  type        = string
  default     = "verify_email"
  
}

variable "pubsub_publisher_binding_role" {
  description = "The role to grant to the Pub/Sub publisher."
  type        = string
  default     = "roles/pubsub.publisher"
  
}

variable "message_retention_duration_pubsub" {
  description = "The duration to retain messages in the Pub/Sub topic."
  type        = string
  default     = "604800s"
  
}

variable "cloud_function_service_account" {
  description = "The service account to use for the Cloud Function."
  type        = string
  default     = "cloud-function-service-account"
  
}

variable "cloud_function_service_account_display_name" {
  description = "The display name for the Cloud Function service account."
  type        = string
  default     = "Cloud Function Service Account"
  
}

variable "service_account_storage_viewer_role" {
  description = "The role to grant to the storage viewer service account."
  type        = string
  default     = "roles/storage.objectViewer"
  
}

variable "cloud_function_vpc_connector_name" {
  description = "The name of the VPC connector for the Cloud Function."
  type        = string
  default     = "cf-verify-email-connector"
  
}

variable "cloud_function_vpc_connector_cidr" {
  description = "The CIDR block for the VPC connector for the Cloud Function."
  type        = string
  default     = "10.8.0.0/28" 
  
}

variable "service_account_sql_client_role" {
  description = "The role to grant to the Cloud Function service account."
  type        = string
  default     = "roles/cloudsql.client"
  
}

variable "service_account_run_invoker_role" {
  description = "The role to grant to the Cloud Function service account."
  type        = string
  default     = "roles/run.invoker"
  
}

variable "verify_email_function_name" {
  description = "The name of the Cloud Function."
  type        = string
  default     = "EmailVerificationFunction"
  
}

variable "verify_email_function_runtime" {
  description = "The runtime for the Cloud Function."
  type        = string
  default     = "java17"
  
}

variable "verify_email_function_entry_point" {
  description = "The entry point for the Cloud Function."
  type        = string
  default     = "gcfv2pubsub.EmailVerificationFunction"
  
}

variable "verify_email_function_description" {
  description = "The description for the Cloud Function."
  type        = string
  default     = "Function to process email verification"
  
}

variable "cloud_function_memory" {
  description = "The memory allocated to the Cloud Function."
  type        = string
  default     = "256Mi"
  
}

variable "storage_source_bucket" {
  description = "The name of the source bucket."
  type        = string
  default     = "webapp-verify-email-dev-bucket"
  
}

variable "storage_source_object" {
  description = "The role to grant to the source bucket."
  type        = string
  default     = "verify-email-function-source.zip"
  
}

variable "max_instance_count" {
  description = "The maximum number of instances for the Cloud Function."
  type        = number
  default     = 3
  
}

variable "min_instance_count" {
  description = "The minimum number of instances for the Cloud Function."
  type        = number
  default     = 1
  
}

variable "timeout_seconds" {
  description = "The timeout for the Cloud Function."
  type        = number
  default     = 60
  
}

variable "ingress_settings" {
  description = "The ingress settings for the Cloud Function."
  type        = string
  default     = "ALLOW_INTERNAL_ONLY"
  
}

variable "all_traffic_on_latest_revision" {
  description = "Whether all traffic is sent to the latest revision."
  type        = bool
  default     = true
  
}

variable "event_type" {
  description = "The event type for the Cloud Function."
  type        = string
  default     = "google.cloud.pubsub.topic.v1.messagePublished"
  
}

variable "retry_policy" {
  description = "The retry policy for the Cloud Function."
  type        = string
  default     = "RETRY_POLICY_DO_NOT_RETRY"
  
}

variable "verify_email_subscription_name" {
  description = "The name of the Pub/Sub subscription for verifying emails."
  type        = string
  default     = "verify-email-subscription"
}

variable "ack_deadline_seconds" {
  description = "The maximum time after a subscriber receives a message before the subscriber should acknowledge the message."
  type        = number
  default     = 20
}

variable "message_retention_duration_subscription" {
  description = "How long Pub/Sub retains the messages in a subscription."
  type        = string
  default     = "604800s" 
}

variable "retain_acked_messages" {
  description = "Whether to retain acknowledged messages."
  type        = bool
  default     = false
}

variable "subscription_expiration_ttl" {
  description = "The TTL of the subscription."
  type        = string
  default     = "604800s"
}


variable "cf_service_account_subscriber_role" {
  description = "The role to grant to the Cloud Function service account."
  type        = string
  default     = "roles/pubsub.subscriber"
  
}