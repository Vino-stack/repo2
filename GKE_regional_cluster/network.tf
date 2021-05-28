#Network resources

resource "google_compute_network" "vpc-net"{
  name=var.vpc-name
  auto_create_subnetworks = "false"
  routing_mode = "REGIONAL"
}
resource "google_compute_subnetwork" "vpc-subnet" {
  name = var.vpc-subnet
  region = var.region
  ip_cidr_range="10.26.2.0/24"
  depends_on    = [google_compute_network.vpc-net]
  network= var.vpc-name
}
resource "google_compute_firewall" "vpcf" {
  name    = var.vpc-firewall
  network = google_compute_network.vpc-net.id

  allow {
    protocol = "icmp"
  }
  allow {
    protocol = "tcp"
    ports    = ["22","80"]
  }
  source_ranges = ["0.0.0.0/0"]
}
