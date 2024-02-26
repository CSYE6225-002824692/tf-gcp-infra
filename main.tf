provider "google" {
  project = var.project
  region  = var.region
}

# Create the VPC
resource "google_compute_network" "vpc" {
  name                            = "${var.vpc_name}-vpc"
  auto_create_subnetworks         = false
  routing_mode                    = var.routing_mode
  delete_default_routes_on_create = true
}

# Create the 'webapp' subnet in the VPC
resource "google_compute_subnetwork" "webapp_subnet" {
  name          = var.webapp_subnet_name
  ip_cidr_range = var.webapp_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
}

# Create the 'db' subnet in the VPCterraform apply -var "vpc_name=vpc1"
resource "google_compute_subnetwork" "db_subnet" {
  name          = var.db_subnet_name
  ip_cidr_range = var.db_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
}

# Add a route to 0.0.0.0/0
resource "google_compute_route" "webapp_internet_route" {
  name             = "${var.vpc_name}-internet-route"
  dest_range       = var.dest_range_webapp_internet_route
  network          = google_compute_network.vpc.id
  next_hop_gateway = var.next_hop_gateway
}

# Reserve an IP range for the private services in the VPC
resource "google_compute_global_address" "private_services_range" {
  name          = "${var.vpc_name}-private-services-range"
  purpose       = var.purpose_private_services_range
  address_type  = var.address_type_private_services_range
  network       = google_compute_network.vpc.self_link
  address       = var.address_private_services_range
  prefix_length = var.prefix_length_private_services_range
}

# Establish a private connection to Google services
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc.id
  service                 = var.service_networking_connection
  reserved_peering_ranges = [google_compute_global_address.private_services_range.name]
}

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

resource "google_sql_database" "webapp_database" {
  name     = var.webapp_db_name
  instance = google_sql_database_instance.mysql.name
}

resource "random_password" "webapp_password" {
  length           = 16
  special          = true
  override_special = var.override_special
}

resource "google_sql_user" "webapp_user" {
  name     = var.webapp_user
  instance = google_sql_database_instance.mysql.name
  password = random_password.webapp_password.result
}

resource "google_compute_firewall" "allow_web_traffic" {
  name    = "${var.vpc_name}-allow-web"
  network = google_compute_network.vpc.id

  allow {
    protocol = var.protocol
    ports    = var.webapp_port
  }

  source_ranges = [var.firewall_allow_source_ranges]
}

resource "google_compute_firewall" "deny_ssh" {
  name    = "${var.vpc_name}-deny-ssh"
  network = google_compute_network.vpc.id

  deny {
    protocol = var.protocol
    ports    = var.ssh_port
  }

  source_ranges = [var.firewall_deny_source_ranges]
}

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
    scopes = var.service_account_scopes
  }

  metadata = {
    db-user     = google_sql_user.webapp_user.name
    db-password = google_sql_user.webapp_user.password
    db-name     = google_sql_database.webapp_database.name
    db-host     = google_sql_database_instance.mysql.private_ip_address
  }

  metadata_startup_script = file(var.startup_script_path)

}
