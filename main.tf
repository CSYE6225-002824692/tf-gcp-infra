provider "google" {
  project = var.project
  region  = var.region
}

# Create the VPC
resource "google_compute_network" "vpc" {
  name                       = "${var.vpc_name}-vpc"
  auto_create_subnetworks    = false
  routing_mode               = var.routing_mode
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
  dest_range       = "0.0.0.0/0"
  network          = google_compute_network.vpc.id
  next_hop_gateway = "default-internet-gateway"
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

  tags = ["web", "application"]
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

}
