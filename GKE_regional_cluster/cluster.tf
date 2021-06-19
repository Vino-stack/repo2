
data "google_client_config" "provider" {}

/* data "google_container_cluster" "my_cluster" {
  name     = "my-gke-cluster"
  location = "us-central1"
  project= var.gcp_project_id
} */

provider "kubernetes" {
  host  = "https://${google_container_cluster.primary.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
  )
}



# Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
resource "google_service_account" "default" {
  account_id   = "vino-terraform-sa"
  display_name = "Service Account"
  project=var.gcp_project_id
}

resource "google_container_cluster" "primary" {
  name     = "my-gke-cluster"
  location = "us-central1"
  remove_default_node_pool = true
  initial_node_count       = 1
  depends_on    = [google_compute_network.vpc-net]
  network = google_compute_network.vpc-net.id
  subnetwork = google_compute_subnetwork.vpc-subnet.id
  project=var.gcp_project_id
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
  name       = "my-node-pool"
  location   = "us-central1"
  cluster    = google_container_cluster.primary.name
  node_count = 1
project=var.gcp_project_id
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

module "my-app-workload-identity" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name       = "my-application-name"
  namespace  = "default"
  project_id =var.gcp_project_id
  //roles = ["roles/storage.Admin", "roles/compute.Admin"]
}
