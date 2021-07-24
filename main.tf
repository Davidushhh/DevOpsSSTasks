provider "google" {
    credentials = file("keyfortf.json")
    project = "vocal-ceiling-318514"
    region = "us-central1"
    zone = "us-central1-c"
}

resource "google_project_service" "api" {
  for_each = toset([
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com"
  ])
  disable_on_destroy = false
  service            = each.value
}

resource "google_compute_firewall" "web" {
    name = "web1"
    network = "default" 
    source_ranges = ["0.0.0.0/0"]
    allow {
        protocol = "tcp"
        ports = ["80", "443"]
    }
}

resource "google_compute_instance" "web_server" {
    name = "tfserver"
    machine_type = "e2-medium"
    boot_disk {
        initialize_params {
            image = "ubuntu-2004-focal-v20210720"
        }
    }
    network_interface {
        network = "default" 
        access_config {}
    }
    metadata_startup_script = <<E0F
#!/bin/bash
apt update -y
apt install apache2 -y
echo "<h2>Apache2 installed on this server by tf.<h2>" > /var/www/html/index.html
systemctl restart apache2
E0F

    depends_on = [google_project_service.api, google_compute_firewall.web]
}


