provider "google" {
  project = "project-d318db8d-3948-41a2-88d" 
  region  = "europe-north2"
}

resource "google_compute_instance" "lowest_spec_instance" {
  name         = "stockholm-micro-instance"
  machine_type = "e2-micro"      # The lowest spec available
  zone         = "europe-north2-a"

  boot_disk {
    initialize_params {
      image = "Ubuntu 22.04 LTS Minimal" # Standard lightweight Linux image
      size  = 10 # Minimum recommended size in GB
    }
  }

  network_interface {
    network = "default"

    # Access config block allows an External IP (Public IP)
    # Remove this block if you only want a Private IP
    access_config {
      // Ephemeral public IP
    }
  }

  # Best practice for low-spec VMs: allow them to be stopped for maintenance
  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }
}