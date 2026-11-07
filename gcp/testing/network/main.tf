resource "google_compute_network" "agentra_api_vpc" {
  name                    = "agentra-api-vpc"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "agentra_api_subnet" {
  name          = "agentra-api-subnet"
  ip_cidr_range = "10.10.0.0/24"
  region        = var.gcp_region
  network       = google_compute_network.agentra_api_vpc.id
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "agentra-api-allow-ssh"
  network = google_compute_network.agentra_api_vpc.name

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "allow_http" {
  name    = "agentra-api-allow-http"
  network = google_compute_network.agentra_api_vpc.name

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
}

output "vpc_name" {
  description = "Name of the custom VPC network"
  value       = google_compute_network.agentra_api_vpc.name
}

output "vpc_self_link" {
  description = "Self-link of the custom VPC network"
  value       = google_compute_network.agentra_api_vpc.self_link
}

output "subnet_name" {
  description = "Name of the subnet"
  value       = google_compute_subnetwork.agentra_api_subnet.name
}

output "subnet_self_link" {
  description = "Self-link of the subnet"
  value       = google_compute_subnetwork.agentra_api_subnet.self_link
}

output "firewall_allow_ssh_name" {
  description = "Name of the SSH firewall rule"
  value       = google_compute_firewall.allow_ssh.name
}

output "firewall_allow_http_name" {
  description = "Name of the HTTP firewall rule"
  value       = google_compute_firewall.allow_http.name
}