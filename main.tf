resource "google_compute_network" "wdc" {
    name = "wdc"
    auto_create_subnetworks=false
    mtu = 1460
}

resource "google_compute_subnetwork" "wdc-subnet" {
    name = "wdc-subnet"
    ip_cidr_range = "10.0.1.0/24"
    region = "europe-central2"
    network=google_compute_network.wdc.id
}

resource "google_compute_firewall" "wdc-ssh-rule" {
  name = "wdc-ssh-rule"
  network = google_compute_network.wdc.id
  allow {
    protocol = "tcp"
    ports = ["22"]
  }
  target_tags = ["vm-instance"]
  source_ranges = ["0.0.0.0/0"]
}


resource "google_compute_firewall" "wdc-http-rule" {
  name = "wdc-http-rule"
  network = google_compute_network.wdc.id
  allow {
    protocol = "tcp"
    ports = ["80"]
  }
  target_tags = ["vm-instance"]
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "default" {
  name         = "my-app"
  machine_type = var.gcp_machine_type
  zone         = var.gcp_zone
  tags         = ["http-server","vm-instance"]

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  

  network_interface {
    network = google_compute_network.wdc.id
    subnetwork = google_compute_subnetwork.wdc-subnet.id

    access_config {
    }
  }
  metadata = {
     sshKeys = "kamilwilnicki:${file(var.ssh_public_key_filepath)}"
   }
  allow_stopping_for_update = true
}
