# Create VPC Network
resource "google_compute_network" "lb_vpc" {
  name                    = "lb-vpc"
  auto_create_subnetworks = false
}

# Create Subnet (regional, required even if LB is global)
resource "google_compute_subnetwork" "lb_subnet" {
  name          = "lb-subnet"
  region        = "us-central1"
  network       = google_compute_network.lb_vpc.id
  ip_cidr_range = "10.88.25.0/24"
}

# Firewall rule to allow HTTP traffic to VMs from LB health checks
resource "google_compute_firewall" "allow_http_healthcheck" {
  name    = "allow-http-healthcheck"
  network = google_compute_network.lb_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  # Google's LB health check IP ranges
  source_ranges = [
    "35.191.0.0/16",
    "130.211.0.0/22"
  ]
}

# Firewall rule to allow SSH (optional, for management)
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = google_compute_network.lb_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}
