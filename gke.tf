data "google_compute_network" "default" {
  name = "default"
}

resource "google_compute_subnetwork" "gke" {
  name          = "gke-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "europe-north2"
  network       = data.google_compute_network.default.id

  secondary_ip_range {
    range_name    = "pod-ranges"
    ip_cidr_range = "192.168.64.0/22"
  }

  secondary_ip_range {
    range_name    = "services-range"
    ip_cidr_range = "192.168.1.0/24"
  }
}

resource "google_container_cluster" "my_vpc_native_cluster" {
  name     = "my-vpc-native-cluster"
  location = "europe-north2"

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = data.google_compute_network.default.id
  subnetwork = google_compute_subnetwork.gke.id

  ip_allocation_policy {
    cluster_secondary_range_name  = "pod-ranges"
    services_secondary_range_name = "services-range"
  }
}

resource "google_container_node_pool" "spot_pool" {
  name     = "spot-pool"
  cluster  = google_container_cluster.my_vpc_native_cluster.name
  location = "europe-north2"

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }

  node_config {
    machine_type = "e2-medium"
    spot         = true
  }
}
