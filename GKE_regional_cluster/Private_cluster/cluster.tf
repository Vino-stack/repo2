resource "google_container_cluster" "cluster" {
  name               = var.cluster_name
  location           =var.cluster_zone
  project            = var.project
 
  network            = google_compute_network.vpc_net.self_link
  subnetwork         = google_compute_subnetwork.vpc_subnet.self_link
  remove_default_node_pool = "true"
  initial_node_count       = 1
  
  private_cluster_config {
    #access through the public endpoint is disabled. creates a private cluster with no client access to the public endpoint.
    enable_private_endpoint = true
   
    #Enables the private cluster feature
    enable_private_nodes = true
   
    #private IP addresses to the cluster master
    master_ipv4_cidr_block = var.master_cidr
  }

  #Internal IP addresses for nodes come from the primary IP address range of the subnet
  #Pod and Service IP addresses come from two subnet secondary IP address range 
  ip_allocation_policy{
    cluster_secondary_range_name = var.cluster_secondary_name
    services_secondary_range_name = var.cluster_service_name
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }
    horizontal_pod_autoscaling {
      disabled = false
    }
  }

  #authentication informations only returned by the API if your service account has permission to get credentials for your GKE cluster
  master_auth {
     username = ""
     password = ""

     client_certificate_config {
       issue_client_certificate = "false"
     }
  }

  #Omit the nested cidr_blocks attribute to disallow external access 
  master_authorized_networks_config {}

}


#NodePool
resource "google_container_node_pool" "nodepool0" {
  cluster      = google_container_cluster.cluster.name
  location     = var.cluster_zone
  project      = var.project
  #version      = data.google_container_engine_versions.gkeversion.latest_node_version
  name    = "dev-pool"
  node_count = var.node_count

  autoscaling {
    min_node_count = var.autoscaling_min_node_count
    max_node_count = var.autoscaling_max_node_count
  }
  
  node_config {
    preemptible  = true
    disk_size_gb = var.disk_size_gb
    disk_type    = var.disk_type
    machine_type = var.machine_type
    service_account    = var.service_account_email
 
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
 
  depends_on = [google_container_cluster.cluster]
}
