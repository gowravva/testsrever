# ---------------------------------------------------------------------------
# Data source: latest Debian 12 boot image
# ---------------------------------------------------------------------------
data "google_compute_image" "debian_12" {
  family  = "debian-12"
  project = "debian-cloud"
}

# ---------------------------------------------------------------------------
# Data sources: reference network resources deployed by the 'network' stack
# ---------------------------------------------------------------------------
data "google_compute_network" "agentra_api_vpc" {
  name = "agentra-api-vpc"
}

data "google_compute_subnetwork" "agentra_api_subnet" {
  name   = "agentra-api-subnet"
  region = var.gcp_region
}

# ---------------------------------------------------------------------------
# Compute Engine VM
# ---------------------------------------------------------------------------
resource "google_compute_instance" "agentra_api" {
  name         = "agentra-api"
  machine_type = "e2-micro"
  zone         = "asia-south1-b"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian_12.self_link
      type  = "pd-standard"
      size  = 20
    }
  }

  network_interface {
    network    = data.google_compute_network.agentra_api_vpc.self_link
    subnetwork = data.google_compute_subnetwork.agentra_api_subnet.self_link

    # Ephemeral external IP - empty access_config block auto-assigns one
    access_config {}
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update -y
    apt-get install -y apache2

    # Configure Apache to listen on port 8080 instead of 80
    sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf
    sed -i 's/<VirtualHost \*:80>/<VirtualHost *:8080>/' /etc/apache2/sites-enabled/000-default.conf

    # Write the served page
    echo "Hello from Agentra API" > /var/www/html/index.html

    # Restart Apache to apply changes
    systemctl restart apache2
    systemctl enable apache2
  EOT

  labels = {
    stack      = "compute"
    managed-by = "opentofu"
  }

  # Ensure the instance can be destroyed without manual intervention
  allow_stopping_for_update = true

  depends_on = [
    data.google_compute_network.agentra_api_vpc,
    data.google_compute_subnetwork.agentra_api_subnet,
  ]
}

# ---------------------------------------------------------------------------
# Outputs
# ---------------------------------------------------------------------------
output "instance_id" {
  description = "The GCE instance ID of the agentra-api VM."
  value       = google_compute_instance.agentra_api.instance_id
}

output "external_ip" {
  description = "The ephemeral external (public) IP address of the agentra-api VM."
  value       = google_compute_instance.agentra_api.network_interface[0].access_config[0].nat_ip
}

output "ssh_command" {
  description = "SSH command to connect to the agentra-api VM as the default Debian user."
  value       = "ssh debian@${google_compute_instance.agentra_api.network_interface[0].access_config[0].nat_ip}"
}