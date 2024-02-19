provider "google" {
  project = "csye-6225-414318"
  region  = var.region
}

# Create the VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.vpc_name}-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
  delete_default_routes_on_create = true
}

# Create the 'webapp' subnet in the VPC
resource "google_compute_subnetwork" "webapp_subnet" {
  name          = "${var.vpc_name}-webapp"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
}

# Create the 'db' subnet in the VPCterraform apply -var "vpc_name=vpc1"
resource "google_compute_subnetwork" "db_subnet" {
  name          = "${var.vpc_name}-db"
  ip_cidr_range = "10.0.2.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
}

# Add a route to 0.0.0.0/0
resource "google_compute_route" "webapp_internet_route" {
  name             = "${var.vpc_name}-internet-route"
  dest_range       = "0.0.0.0/0"
  network          = 
  next_hop_gateway = "default-internet-gateway"
}
