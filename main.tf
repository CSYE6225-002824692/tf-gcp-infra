# Define the Google Cloud provider with project and region from variables
provider "google" {
  project = var.project
  region  = var.region
}

# Define a Virtual Private Cloud (VPC) with custom settings including routing mode and disabling auto-creation of subnetworks
resource "google_compute_network" "vpc" {
  name                            = "${var.vpc_name}-vpc"
  auto_create_subnetworks         = false
  routing_mode                    = var.routing_mode
  delete_default_routes_on_create = true
}

# Define a 'webapp' subnet within the VPC, specifying its CIDR range, region, and associating it with the VPC network
resource "google_compute_subnetwork" "webapp_subnet" {
  name          = var.webapp_subnet_name
  ip_cidr_range = var.webapp_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
}

# Define a 'db' subnet within the VPC for database services, with its own CIDR range and region
resource "google_compute_subnetwork" "db_subnet" {
  name          = var.db_subnet_name
  ip_cidr_range = var.db_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
}

# Create an internet route for the 'webapp' subnet, defining the destination range and next-hop internet gateway
resource "google_compute_route" "webapp_internet_route" {
  name             = "${var.vpc_name}-internet-route"
  dest_range       = var.dest_range_webapp_internet_route
  network          = google_compute_network.vpc.id
  next_hop_gateway = var.next_hop_gateway
}

# Reserve a global IP range for private services within the VPC, specifying the range, type, and purpose
resource "google_compute_global_address" "private_services_range" {
  name          = "${var.vpc_name}-private-services-range"
  purpose       = var.purpose_private_services_range
  address_type  = var.address_type_private_services_range
  network       = google_compute_network.vpc.self_link
  address       = var.address_private_services_range
  prefix_length = var.prefix_length_private_services_range
}

# Establish a private connection to Google services using the VPC network and the reserved IP range for peering
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = var.service_networking_connection
  reserved_peering_ranges = [google_compute_global_address.private_services_range.name]
}

resource "google_kms_key_ring" "key_ring" {
  name     = var.key_ring
  location = var.region
}

# CMEK for Virtual Machines
resource "google_kms_crypto_key" "vm_crypto_key" {
  name            = var.vm_crypto_key
  key_ring        = google_kms_key_ring.key_ring.id
  rotation_period = var.rotation_period

  lifecycle {
    prevent_destroy = false
  }
}

# CMEK for CloudSQL Instances
resource "google_kms_crypto_key" "cloudsql_crypto_key" {
  name            = var.cloudsql_crypto_key
  key_ring        = google_kms_key_ring.key_ring.id
  rotation_period = var.rotation_period

  lifecycle {
    prevent_destroy = false
  }
}

# CMEK for Cloud Storage Buckets
resource "google_kms_crypto_key" "storage_crypto_key" {
  name            = var.storage_crypto_key
  key_ring        = google_kms_key_ring.key_ring.id
  rotation_period = var.rotation_period

  lifecycle {
    prevent_destroy = false
  }
}

resource "google_project_service_identity" "gcp_sa_cloud_sql" {
  project  = var.project
  provider = google-beta
  service  = var.gcp_sa_cloud_sql_service_identity
}

resource "google_kms_crypto_key_iam_binding" "crypto_key" {
  provider      = google-beta
  crypto_key_id = google_kms_crypto_key.cloudsql_crypto_key.id
  role          = var.crypto_key_binding

  members = [
    "serviceAccount:${google_project_service_identity.gcp_sa_cloud_sql.email}",
  ]
}

# Create a Cloud SQL database instance with specific settings including version, region, and network settings
resource "google_sql_database_instance" "mysql" {
  name                = var.cloud_sql_instance_name
  project             = var.project
  region              = var.region
  database_version    = var.database_version
  deletion_protection = var.deletion_protection_enabled
  encryption_key_name = google_kms_crypto_key.cloudsql_crypto_key.id

  settings {
    tier              = var.tier_db
    activation_policy = var.activation_policy_db
    disk_autoresize   = var.disk_autoresize_db
    backup_configuration {
      enabled            = var.backup_configuration_enabled 
      binary_log_enabled = var.binary_log_enabled_db
    }
    ip_configuration {
      ipv4_enabled    = var.ipv4_enabled_db
      private_network = google_compute_network.vpc.id
    }
    disk_type = var.disk_type_db
    disk_size = var.disk_size_db

    availability_type           = var.availability_type_db
    deletion_protection_enabled = var.deletion_protection_enabled

  }
  
  depends_on = [
    google_service_networking_connection.private_vpc_connection,
    google_project_service_identity.gcp_sa_cloud_sql,
    google_kms_crypto_key.cloudsql_crypto_key,
    google_kms_key_ring.key_ring

  ]
}

# Create a database within the Cloud SQL instance for the web application
resource "google_sql_database" "webapp_database" {
  name     = var.webapp_db_name
  instance = google_sql_database_instance.mysql.name
}

# Generate a random password for the web application database user
resource "random_password" "webapp_password" {
  length           = 16
  special          = true
  override_special = var.override_special
}

# Create a user for the web application database with the generated password
resource "google_sql_user" "webapp_user" {
  name     = var.webapp_user
  instance = google_sql_database_instance.mysql.name
  password = random_password.webapp_password.result
}

# Create a firewall rule to deny SSH traffic to the VPC, specifying denied protocols and ports
resource "google_compute_firewall" "deny_ssh" {
  name    = "${var.vpc_name}-deny-ssh"
  network = google_compute_network.vpc.id

  deny {
    protocol = var.protocol
    ports    = var.ssh_port
  }

  source_ranges = [var.firewall_deny_source_ranges]
}

# Create a service account for VM instances, specifying the account ID and display name
resource "google_service_account" "vm_service_account" {
  account_id   = var.vm_service_account
  display_name = var.vm_service_account_display_name
  project      = var.project
}

# Assign the logging admin role to the VM service account at the project level
resource "google_project_iam_binding" "logging_admin_binding" {
  project = var.project
  role    = var.logging_admin_role

  members = [
    "serviceAccount:${google_service_account.vm_service_account.email}",
  ]

  depends_on = [
      google_service_account.vm_service_account
  ]
}

# Assign the monitoring metric writer role to the VM service account at the project level
resource "google_project_iam_binding" "monitoring_metric_writer_binding" {
  project = var.project
  role    = var.monitoring_metric_writer_role

  members = [
    "serviceAccount:${google_service_account.vm_service_account.email}",
  ]

  depends_on = [
      google_service_account.vm_service_account
  ]
}

resource "google_project_iam_binding" "pubsub_publisher_binding" {
  project = var.project
  role    = var.pubsub_publisher_binding_role

  members = [
    "serviceAccount:${google_service_account.vm_service_account.email}",
  ]

  depends_on = [
    google_service_account.vm_service_account
  ]
}

data "google_project" "current" {
}

resource "google_kms_crypto_key_iam_binding" "crypto_vm_key_iam" {
  crypto_key_id = google_kms_crypto_key.vm_crypto_key.id
  role          = var.crypto_key_binding
  members       = [
    "serviceAccount:service-${data.google_project.current.number}@compute-system.iam.gserviceaccount.com",
  ]
}

resource "google_compute_region_instance_template" "webapp_template" {
  name         = "${var.instance_name}-template"
  machine_type = var.machine_type
  region       = var.region
  disk {
    source_image = var.boot_disk_image
    auto_delete  = true
    boot         = true
    disk_encryption_key {
      kms_key_self_link = google_kms_crypto_key.vm_crypto_key.id
    }
  }
  network_interface {
    network    = google_compute_network.vpc.id
    subnetwork = google_compute_subnetwork.webapp_subnet.id
    access_config {
      network_tier = var.vm_network_tier
    }
  }

  service_account {
    email  = google_service_account.vm_service_account.email
    scopes = var.service_account_scopes
  }

  metadata = {
    db-user     = google_sql_user.webapp_user.name
    db-password = google_sql_user.webapp_user.password
    db-name     = google_sql_database.webapp_database.name
    db-host     = google_sql_database_instance.mysql.private_ip_address
  }

  metadata_startup_script = file(var.startup_script_path)

  depends_on = [ google_kms_crypto_key_iam_binding.crypto_vm_key_iam  ]
  
}

resource "google_compute_region_instance_group_manager" "webapp_instance_group_manager" {
  name = "${var.instance_name}-instance-group-manager"
  region = var.region
  base_instance_name = var.instance_name
  target_size = 1
  version {
    instance_template = google_compute_region_instance_template.webapp_template.self_link
  }
  named_port {
    name = var.named_port_name
    port = var.named_port_port
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.webapp_health_check.id
    initial_delay_sec = var.initial_delay_sec  
  }

  depends_on = [
    google_compute_region_instance_template.webapp_template
  ]
}

resource "google_compute_health_check" "webapp_health_check" {
  name               = "${var.instance_name}-health-check"
  check_interval_sec = var.check_interval_sec
  timeout_sec        = var.timeout_sec
  healthy_threshold  = var.healthy_threshold
  unhealthy_threshold = var.unhealthy_threshold
  http_health_check {
    port    = var.named_port_port
    request_path = var.health_check_request_path
  }
}

resource "google_compute_region_autoscaler" "webapp_autoscaler" {
  name   = "${var.instance_name}-autoscaler"
  target = google_compute_region_instance_group_manager.webapp_instance_group_manager.id
  region = var.region

  autoscaling_policy {
    max_replicas    = var.auto_scaling_max_instances
    min_replicas    = var.auto_scaling_min_instances
    cooldown_period = var.cooldown_period
    cpu_utilization {
      target = var.cpu_utilization_target
    }
  }
}
data "google_dns_managed_zone" "existing_zone" {
  name = var.existing_dns_managed_zone
}

# Create the Pub/Sub topic named 'verify_email'
resource "google_pubsub_topic" "verify_email_topic" {
  name = var.pubsub_topic_name
  message_retention_duration = var.message_retention_duration_pubsub
}

resource "google_pubsub_subscription" "verify_email_subscription" {
  name  = var.verify_email_subscription_name
  topic = google_pubsub_topic.verify_email_topic.name

  ack_deadline_seconds = var.ack_deadline_seconds

  message_retention_duration = var.message_retention_duration_subscription
  retain_acked_messages      = var.retain_acked_messages

  expiration_policy {
    ttl = var.subscription_expiration_ttl
  }
}


# Create a service account for the Cloud Function
resource "google_service_account" "cloud_function_service_account" {
  account_id   = var.cloud_function_service_account
  display_name = var.cloud_function_service_account_display_name
}

resource "google_project_iam_binding" "service_account_storage_viewer" {
  project = var.project
  role    = var.service_account_storage_viewer_role

  members = [
    "serviceAccount:${google_service_account.cloud_function_service_account.email}",
  ]

  depends_on = [
      google_service_account.cloud_function_service_account
  ]
}

resource "google_project_iam_binding" "cf_service_account_subscriber_role" {
  project = var.project
  role    = var.cf_service_account_subscriber_role

  members = [
    "serviceAccount:${google_service_account.cloud_function_service_account.email}",
    ]

  depends_on = [
      google_service_account.cloud_function_service_account
  ]
}


resource "google_vpc_access_connector" "cloud_function_vpc_connector" {
  name          = var.cloud_function_vpc_connector_name
  project       = var.project
  region        = var.region
  network       = google_compute_network.vpc.id
  ip_cidr_range = var.cloud_function_vpc_connector_cidr
}

# Assign the monitoring metric writer role to the VM service account at the project level
resource "google_project_iam_binding" "service_account_sql_client" {
  project = var.project
  role    = var.service_account_sql_client_role

  members = [
    "serviceAccount:${google_service_account.cloud_function_service_account.email}",
  ]

  depends_on = [
      google_service_account.cloud_function_service_account
  ]
}

resource "google_project_iam_binding" "service_account_run_invoker" {
  project = var.project
  role    = var.service_account_run_invoker_role

  members = [
    "serviceAccount:${google_service_account.cloud_function_service_account.email}",
  ]

  depends_on = [
      google_service_account.cloud_function_service_account
  ]
}

resource "google_kms_crypto_key_iam_binding" "crypto_key_iam" {
  crypto_key_id = google_kms_crypto_key.storage_crypto_key.id
  role          = var.crypto_key_binding
  members       = [
    "serviceAccount:service-${data.google_project.current.number}@gs-project-accounts.iam.gserviceaccount.com",
  ]
}

resource "random_id" "bucket_prefix" {
  byte_length = 8
}

resource "google_storage_bucket" "gcf_bucket" {
  name                        = "webapp-${random_id.bucket_prefix.hex}-gcf-source"
  location                    = var.region
  uniform_bucket_level_access = true
  encryption {
    default_kms_key_name = google_kms_crypto_key.storage_crypto_key.id
  }

  depends_on = [ google_kms_crypto_key_iam_binding.crypto_key_iam ]
  
}

resource "google_storage_bucket_object" "verify_email_gcf_object" {
  name   = var.storage_source_object
  bucket = google_storage_bucket.gcf_bucket.name
  source = "${path.root}/${var.storage_source_object}"
}

resource "google_storage_bucket_object" "verify_email_gcf_template_object" {
  name   = var.verify_email_gcf_template_object_name
  bucket = google_storage_bucket.gcf_bucket.name
  source = "${path.root}/${var.verify_email_gcf_template_object_name}"
}

# Create a Cloud Function triggered by the 'verify_email' topic
resource "google_cloudfunctions2_function" "verify_email_function" {
  name                  = var.verify_email_function_name
  description           = var.verify_email_function_description
  location              = var.region

  build_config {
    runtime               = var.verify_email_function_runtime
    entry_point           = var.verify_email_function_entry_point

    source {
      storage_source {
        bucket = google_storage_bucket.gcf_bucket.name
        object = google_storage_bucket_object.verify_email_gcf_object.name
      }
    }
  }

  service_config {
    available_memory   = var.cloud_function_memory
    max_instance_count = var.max_instance_count
    min_instance_count = var.min_instance_count
    timeout_seconds    = var.timeout_seconds

    environment_variables = {
      DB_NAME = google_sql_database.webapp_database.name
      DB_USERNAME = google_sql_user.webapp_user.name
      DB_PASSWORD = google_sql_user.webapp_user.password
      INSTANCE_CONNECTION_NAME = google_sql_database_instance.mysql.connection_name
      GCS_BUCKET_NAME = google_storage_bucket.gcf_bucket.name
      EMAIL_TEMPLATE_FILENAME = google_storage_bucket_object.verify_email_gcf_template_object.name
      MAILGUN_DOMAIN = var.mailgun_domain
      MAILGUN_DOMAIN_API_KEY = var.mailgun_domain_api_key
      FROM_EMAIL = var.from_email
      FROM_NAME = var.from_name
      VERIFICATION_LINK = var.verification_link
    }

    ingress_settings               = var.ingress_settings
    all_traffic_on_latest_revision = var.all_traffic_on_latest_revision
    service_account_email          = google_service_account.cloud_function_service_account.email
    vpc_connector = google_vpc_access_connector.cloud_function_vpc_connector.name
  }
  

  event_trigger {
    trigger_region = var.region
    event_type     = var.event_type
    pubsub_topic   = google_pubsub_topic.verify_email_topic.id
    retry_policy   = var.retry_policy
    service_account_email = google_service_account.cloud_function_service_account.email
  }

  depends_on = [ google_vpc_access_connector.cloud_function_vpc_connector ]
}

resource "google_compute_managed_ssl_certificate" "webapp_lb_ssl_cert" {
  name = var.webapp_lb_ssl_certificate
  managed {
    domains = var.domains
  }
}

resource "google_compute_backend_service" "webapp_lb_backend_service" {
  name        = var.webapp_lb_backend_service_name
  protocol    = var.webapp_lb_backend_service_protocol
  port_name   = var.named_port_name
  timeout_sec = var.webapp_lb_backend_service_timeout
  health_checks = [google_compute_health_check.webapp_health_check.id]
  load_balancing_scheme = var.webapp_lb_backend_service_load_balancing_scheme
  backend {
    group = google_compute_region_instance_group_manager.webapp_instance_group_manager.instance_group
    balancing_mode = var.webapp_lb_backend_service_balancing_mode
    capacity_scaler = var.webapp_lb_backend_service_capacity_scaler
    max_utilization = var.webapp_lb_backend_service_max_utilization
  }
  depends_on = [google_compute_region_instance_group_manager.webapp_instance_group_manager]
}

resource "google_compute_url_map" "webapp_lb_url_map" {
  name            = var.webapp_lb_url_map_name
  default_service = google_compute_backend_service.webapp_lb_backend_service.id
  depends_on      = [google_compute_backend_service.webapp_lb_backend_service]
}

resource "google_compute_target_https_proxy" "webapp_lb_https_proxy" {
  name             = var.webapp_lb_https_proxy_name
  url_map          = google_compute_url_map.webapp_lb_url_map.id
  ssl_certificates = [google_compute_managed_ssl_certificate.webapp_lb_ssl_cert.id]
  depends_on       = [google_compute_managed_ssl_certificate.webapp_lb_ssl_cert]
}

resource "google_compute_global_forwarding_rule" "webapp_lb_forwarding_rule" {
  name       = var.webapp_lb_forwarding_rule_name
  target     = google_compute_target_https_proxy.webapp_lb_https_proxy.id
  port_range = var.webapp_lb_forwarding_rule_port
  ip_protocol = var.webapp_lb_forwarding_rule_ip_protocol
  load_balancing_scheme = var.webapp_lb_forwarding_rule_load_balancing_scheme
}

data "google_compute_global_forwarding_rule" "webapp_lb_forwarding_rule" {
  name = var.webapp_lb_forwarding_rule_name
  depends_on = [google_compute_global_forwarding_rule.webapp_lb_forwarding_rule]
}

resource "google_dns_record_set" "vm_a_record" {
  name         = var.vm_a_record_name
  type         = var.vm_a_record_type
  ttl          = var.vm_a_record_ttl
  managed_zone = data.google_dns_managed_zone.existing_zone.name
  rrdatas = [data.google_compute_global_forwarding_rule.webapp_lb_forwarding_rule.ip_address]

  depends_on = [google_compute_global_forwarding_rule.webapp_lb_forwarding_rule]
}

resource "google_compute_firewall" "health_check_allow_firewall" {
  name    = "${var.vpc_name}-internal"
  network = google_compute_network.vpc.id
  allow {
    protocol = var.health_check_firewall_allow_protocol
    ports    = var.health_check_allow_firewall_ports
  }
  source_ranges = var.health_check_allow_firewall_source_ranges 
}

resource "google_secret_manager_secret" "db_user_secret" {
  secret_id = var.db_user_secret_name
  labels = {
    label = var.db_user_secret_name
  }

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_user_secret_version" {
  secret      = google_secret_manager_secret.db_user_secret.id
  secret_data = base64encode(google_sql_user.webapp_user.name)
}

resource "google_secret_manager_secret" "db_password_secret" {
  secret_id = var.db_password_secret_name
  labels = {
    label = var.db_password_secret_name
  }

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_password_secret_version" {
  secret      = google_secret_manager_secret.db_password_secret.id
  secret_data = base64encode(google_sql_user.webapp_user.password)
}


resource "google_secret_manager_secret" "db_name_secret" {
  secret_id = var.db_name_secret_name
  labels = {
    label = var.db_name_secret_name
  }

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_name_secret_version" {
  secret      = google_secret_manager_secret.db_name_secret.id
  secret_data = base64encode(google_sql_database.webapp_database.name)
}


resource "google_secret_manager_secret" "db_host_secret" {
  secret_id = var.db_host_secret_name
  labels = {
    label = var.db_host_secret_name
  }

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "db_host_secret_version" {
  secret      = google_secret_manager_secret.db_host_secret.id
  secret_data = base64encode(google_sql_database_instance.mysql.private_ip_address)
}

resource "google_secret_manager_secret" "kms_key_self_link_secret" {
  secret_id = var.kms_key_self_link_secret_name
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "kms_key_self_link_secret_version" {
  secret      = google_secret_manager_secret.kms_key_self_link_secret.id
  secret_data = base64encode(google_kms_crypto_key.vm_crypto_key.id)
}


resource "google_secret_manager_secret" "network_id_secret" {
  secret_id = var.network_id_secret_name
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "network_id_secret_version" {
  secret      = google_secret_manager_secret.network_id_secret.id
  secret_data = base64encode(google_compute_network.vpc.id)
}


resource "google_secret_manager_secret" "subnetwork_id_secret" {
  secret_id = var.subnetwork_id_secret_name
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "subnetwork_id_secret_version" {
  secret      = google_secret_manager_secret.subnetwork_id_secret.id
  secret_data = base64encode(google_compute_subnetwork.webapp_subnet.id)
}

resource "google_secret_manager_secret" "service_account_email_secret" {
  secret_id = var.service_account_email_secret_name
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "service_account_email_secret_version" {
  secret      = google_secret_manager_secret.service_account_email_secret.id
  secret_data = base64encode(google_service_account.vm_service_account.email)
}


resource "google_secret_manager_secret" "MIG_secret" {
  secret_id = var.MIG_secret_name
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "MIG_secret_version" {
  secret      = google_secret_manager_secret.MIG_secret.id
  secret_data = base64encode(google_compute_region_instance_group_manager.webapp_instance_group_manager.name)
}