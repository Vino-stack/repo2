resource "null_resource" "gen_certificate" {
  provisioner "local-exec" {
    command = <<EOF
        "timeout 60m install_istio.sh"
        chmod +x install_istio.sh
        ./install_istio.sh
    EOF
  }
depends_on = [module.gke]
}


data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = "gcp-training-01-303001"
  name                       = "istio-cluster"
  region                     = "us-central1"
  network                    = "vino-vpc"
  subnetwork                 = "subnet-a"
  ip_range_pods              = ""
  ip_range_services          = ""
  http_load_balancing        = true
  #depends_on = [module.vpc]
  }
