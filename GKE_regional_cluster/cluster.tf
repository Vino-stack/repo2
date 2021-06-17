provider "google"{
  project =var.gcp_project_id
  region =var.region
  zone =var.zone
}

# Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
resource "google_service_account" "default" {
  account_id   = "vino-terraform-sa"
  display_name = "Service Account"
}

resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = "us-central1"
  remove_default_node_pool = true
  initial_node_count       = 1
  depends_on    = [google_compute_network.vpc-net]
  network = google_compute_network.vpc-net.id
  subnetwork = google_compute_subnetwork.vpc-subnet.id

}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool"
  location   = "us-central1"
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = var.vm-machine_type

    # For finegrined access control grant access to specific APIs you want like only for logging and monitoring.
    service_account = google_service_account.default.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform",
      #"https://www.googleapis.com/auth/logging.write",
      #"https://www.googleapis.com/auth/monitoring",
    ]
  }
}

