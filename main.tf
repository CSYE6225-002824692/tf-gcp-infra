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

# Create a Cloud SQL database instance with specific settings including version, region, and network settings
resource "google_sql_database_instance" "mysql" {
  name                = var.cloud_sql_instance_name
  project             = var.project
  region              = var.region
  database_version    = var.database_version
  deletion_protection = var.deletion_protection_enabled

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
    google_service_networking_connection.private_vpc_connection
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

# Create a firewall rule to allow web traffic to the VPC, specifying allowed protocols and ports
resource "google_compute_firewall" "allow_web_traffic" {
  name    = "${var.vpc_name}-allow-web"
  network = google_compute_network.vpc.id

  allow {
    protocol = var.protocol
    ports    = var.webapp_port
  }

  source_ranges = [var.firewall_allow_source_ranges]
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

# Define a VM instance with specific machine type, boot disk, network interface, and service account settings
resource "google_compute_instance" "vm_instance" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone

  tags = var.tags
  boot_disk {
    initialize_params {
      image = var.boot_disk_image
      type  = var.boot_disk_type
      size  = var.boot_disk_size
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

  depends_on = [
      google_service_account.vm_service_account
  ]
}

data "google_dns_managed_zone" "existing_zone" {
  name = var.existing_dns_managed_zone
}

# Define a DNS A record for the VM instance within an existing managed DNS zone
resource "google_dns_record_set" "vm_a_record" {
  name         = var.vm_a_record_name
  type         = var.vm_a_record_type
  ttl          = var.vm_a_record_ttl
  managed_zone = data.google_dns_managed_zone.existing_zone.name
  rrdatas      = [google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip]

  depends_on = [
    google_compute_instance.vm_instance
  ]
}
