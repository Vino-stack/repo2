#VM instance 
resource "google_compute_instance" "gke-bastion-host" {
  name         = "gke-host"
  project      = var.project
  machine_type = "f1-micro"
  zone         = var.zone
  tags         = ["ssh"]

  service_account {
    email = var.service_account_email
    scopes = ["cloud-platform"]
  }

  boot_disk {
    initialize_params {
      image = "centos-7"
    }
  }

  network_interface {
    network      = google_compute_network.vpc_net.self_link
    subnetwork   = google_compute_subnetwork.vpc_subnet.self_link
    access_config {}
  }
  depends_on = [google_container_node_pool.nodepool0]
}
