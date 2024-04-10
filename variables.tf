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

variable "named_port_name" {
  description = "The name of the named port."
  type        = string
  default     = "http"
  
}

variable "named_port_port" {
  description = "The port number of the named port."
  type        = number
  default     = 8080
  
}

variable "health_check_request_path" {
  description = "The request path for the health check."
  type        = string
  default     = "/healthz"
  
}

variable "auto_scaling_min_instances" {
  description = "The minimum number of instances for the auto-scaler."
  type        = number
  default     = 1
  
}

variable "auto_scaling_max_instances" {
  description = "The maximum number of instances for the auto-scaler."
  type        = number
  default     = 3
  
}

variable "cooldown_period" {
  description = "The cooldown period for the auto-scaler."
  type        = number
  default     = 60
  
}

variable "cpu_utilization_target" {
  description = "The target CPU utilization for the auto-scaler."
  type        = number
  default     = 0.2
  
}

variable "webapp_lb_ssl_certificate" {
  description = "The name of the SSL certificate for the load balancer."
  type        = string
  default     = "webapp-ssl-cert"
  
}

variable "domains" {
  description = "The domains to use for the SSL certificate."
  type        = list(string)
  default     = ["csyewebapp.me"]
  
}

variable "webapp_lb_backend_service_name" {
  description = "The name of the backend service for the load balancer."
  type        = string
  default     = "webapp-backend-service"
  
}

variable "webapp_lb_backend_service_protocol" {
  description = "The protocol for the backend service."
  type        = string
  default     = "HTTP"
  
}

variable "webapp_lb_backend_service_timeout" {
  description = "The timeout for the backend service."
  type        = number
  default     = 10
  
}

variable "webapp_lb_url_map_name" {
  description = "The name of the URL map for the load balancer."
  type        = string
  default     = "webapp-url-map"
  
}

variable "webapp_lb_https_proxy_name" {
  description = "The name of the HTTPS proxy for the load balancer."
  type        = string
  default     = "webapp-https-proxy"
  
}

variable "webapp_lb_forwarding_rule_name" {
  description = "The name of the forwarding rule for the load balancer."
  type        = string
  default     = "webapp-forwarding-rule"
  
}

variable "webapp_lb_forwarding_rule_port" {
  description = "The port for the forwarding rule."
  type        = number
  default     = 443
  
}

variable "health_check_firewall_allow_protocol" {
  description = "The protocol for the health check."
  type        = string
  default     = "tcp"
  
}

variable "health_check_allow_firewall_ports" {
  description = "The ports to allow for the health check."
  type        = list(number)
  default     = [8080, 443]
  
}

variable "health_check_allow_firewall_source_ranges" {
  description = "The source ranges to allow for the health check."
  type        = list(string)
  default     = ["130.211.0.0/22", "35.191.0.0/16"] 
  
}

variable "initial_delay_sec" {
  description = "The initial delay for the health check."
  type        = number
  default     = 180
  
}

variable "check_interval_sec" {
  description = "The interval between health checks."
  type        = number
  default     = 30
  
}

variable "timeout_sec" {
  description = "The timeout for the health check."
  type        = number
  default     = 10
  
}

variable "healthy_threshold" {
  description = "The number of successful health checks before the instance is considered healthy."
  type        = number
  default     = 2
  
}

variable "unhealthy_threshold" {
  description = "The number of failed health checks before the instance is considered unhealthy."
  type        = number
  default     = 2
  
}

variable "webapp_lb_forwarding_rule_ip_protocol" {
  description = "The IP protocol for the forwarding rule."
  type        = string
  default     = "TCP"
  
}

variable "webapp_lb_forwarding_rule_load_balancing_scheme" {
  description = "The load balancing scheme for the forwarding rule."
  type        = string
  default     = "EXTERNAL_MANAGED"
  
}

variable "webapp_lb_backend_service_load_balancing_scheme" {
  description = "The load balancing scheme for the backend service."
  type        = string
  default     = "EXTERNAL_MANAGED"
  
}

variable "webapp_lb_backend_service_balancing_mode" {
  description = "The balancing mode for the backend service."
  type        = string
  default     = "UTILIZATION"
  
}

variable "webapp_lb_backend_service_capacity_scaler" {
  description = "The capacity scaler for the backend service."
  type        = number
  default     = "1.0"
  
}

variable "webapp_lb_backend_service_max_utilization" {
  description = "The maximum utilization for the backend service."
  type        = number
  default     = "0.8"
  
}

variable "key_ring" {
  description = "The name of the key ring."
  type        = string
  default     = "webapp-key-ring"
  
}

variable "vm_crypto_key" {
  description = "The name of the crypto key for the VM."
  type        = string
  default     = "vm-crypto-key"
  
}

variable "cloudsql_crypto_key" {
  description = "The name of the crypto key for Cloud SQL."
  type        = string
  default     = "cloudsql-crypto-key"
  
}

variable "storage_crypto_key" {
  description = "The name of the crypto key for Cloud Storage."
  type        = string
  default     = "storage-crypto-key"
  
}

variable "rotation_period" { 
  description = "The rotation period for the crypto key."
  type        = string
  default     = "2592000s"
  
}

variable "gcp_sa_cloud_sql_service_identity" {
  description = "The service account for Cloud SQL."
  type        = string
  default     = "sqladmin.googleapis.com"
  
}

variable "crypto_key_binding" {
  description = "The role to grant to the crypto key."
  type        = string
  default     = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  
}

variable "verify_email_gcf_template_object_name" {
  description = "The name of the object for the Cloud Function template."
  type        = string
  default     = "email_template.html"
  
}

variable "db_user_secret_name" {
  description = "The name of the secret for the database user."
  type        = string
  default     = "db-user"
  
}

variable "db_password_secret_name" {
  description = "The name of the secret for the database password."
  type        = string
  default     = "db-password"
  
}

variable "db_name_secret_name" {
  description = "The name of the secret for the database name."
  type        = string
  default     = "db-name"
  
}

variable "db_host_secret_name" {
  description = "The name of the secret for the database host."
  type        = string
  default     = "db-host"
  
}

variable "kms_key_self_link_secret_name" {
  description = "The self link of the secret for the KMS key."
  type        = string
  default     = "kms-key-self-link"
  
}

variable "network_id_secret_name" {
  description = "The name of the secret for the network ID."
  type        = string
  default     = "network-id"
  
}

variable "subnetwork_id_secret_name" {
  description = "The name of the secret for the subnetwork ID."
  type        = string
  default     = "subnetwork-id"
  
}

variable "service_account_email_secret_name" {
  description = "The name of the secret for the service account email."
  type        = string
  default     = "service-account-email"
  
}

variable "MIG_secret_name" {
  description = "The name of the secret for the MIG."
  type        = string
  default     = "mig-name"
  
}

variable "mailgun_domain" {
  description = "The domain for Mailgun."
  type        = string
  default     = "csyewebapp.me"
  
}

variable "mailgun_domain_api_key" {
  description = "The API key for the Mailgun domain."
  type        = string
  default     = "6c771365f8c72c6d4e4b647c7aade9f8-309b0ef4-9b9ce17b"
  
}

variable "from_email" {
  description = "The email address to send from."
  type        = string
  default     = "noreply@csyewebapp.me"
  
}

variable "from_name" {
  description = "The name to send from."
  type        = string
  default     = "CSYEwebapp"
  
}

variable "verification_link" {
  description = "The link to verify the email."
  type        = string
  default     = "https://csyewebapp.me/verifyEmail?token="
  
}