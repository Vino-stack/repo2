provider "google"{
  credentials="SAKEY.json"
  project =var.gcp_project_id
  region =var.region
  zone =var.zone
}

#Redis Instance

resource "google_redis_instance" "my_memorystore_redis_instance" {
  name           = var.rins_id
  tier           = var.redis_tire
  memory_size_gb = 2
  region         = var.region
  redis_version  = var.redis_version
  depends_on    = [google_compute_network.vpc-net]
}
output "host" {
 description = "The IP address of the instance."
 value = "${google_redis_instance.my_memorystore_redis_instance.host}"
}

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

#MIG and Instance template
  
  resource "google_compute_instance_template" "tmp1" {
  name = var.mig-tmp-name
  machine_type            = var.vm-machine_type
  metadata_startup_script = file("wp.sh")
  region                  = var.region
  tags = [ "http-server"]

  disk {
    source_image = var.vm_source_image
    disk_size_gb = 10
    auto_delete  = true
    boot         = true
  }

  network_interface {
    network = var.vpc-name
   subnetwork = google_compute_subnetwork.vpc-subnet.id
   access_config {
        }
  }

}

resource "google_compute_region_instance_group_manager" "mig-grp" {
  name               = var.mig-name
  region             = var.region
  base_instance_name = var.base_ins_name
  target_size        = 1

version {
instance_template  = google_compute_instance_template.tmp1.id
}
  
  named_port {
    name = "http"
    port = 80
  }
  
  named_port {
    name = "https"
    port = 443
  }
}

resource "google_compute_region_autoscaler" "wpex" {
  name   = var.mig_autoscaler
  region = var.region
  target = google_compute_region_instance_group_manager.mig-grp.id

  autoscaling_policy {
    max_replicas    = 3
    min_replicas    = 1
    cooldown_period = 60

    cpu_utilization {
      target = 0.6
    }
  }
}

#Reserve Static IP
resource "google_compute_global_address" "sip" {
  name = var.external_IP_name
  ip_version   = "IPV4"
  address_type = "EXTERNAL"
}

#Load Balancer 
resource "google_compute_http_health_check" "hc" {
  name         = var.hc_name
  request_path = "/health"

  timeout_sec        = 5
  check_interval_sec = 5
  port = "80"
}

resource "google_compute_backend_service" "backend" {
  name             = var.lb-backend-name
  protocol         = "HTTP"
  timeout_sec      = 10
  session_affinity = "NONE"

  backend {
    group = google_compute_region_instance_group_manager.mig-grp.instance_group
  }
  health_checks = [google_compute_http_health_check.hc.id]
   
}

resource "google_compute_global_forwarding_rule" "lbfw" {
  name       = var.fw_rule 
  ip_address = google_compute_global_address.sip.address
  port_range = "80"
  target     = google_compute_target_http_proxy.proxy.self_link
}

resource "google_compute_url_map" "mapping" {
  name        = var.lb-url-map
  default_service = google_compute_backend_service.backend.self_link
}

resource "google_compute_target_http_proxy" "proxy" {
  name    = var.proxy-name
  url_map = google_compute_url_map.mapping.self_link
}

