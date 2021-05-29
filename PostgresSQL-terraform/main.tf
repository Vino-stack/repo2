provider "google"{
  credentials="SAKEY.json"
  project =var.gcp_project_id
  region =var.region
  zone =var.zone
}

resource "google_sql_database_instance" "postgresql" {
  name = "${var.app_name}-db1"
  project = var.app_project
  region = var.gcp_region_1
  database_version = var.db_version
  
  settings {
    tier = var.db_tier
    
    #type of the Cloud SQL instance, high availability 
    availability_type = "REGIONAL"
   
    #specifies when the instance should be active. Can be either ALWAYS, NEVER or ON_DEMAND
    activation_policy = var.db_activation_policy
    
    #increase storage size automatically
    disk_autoresize = var.db_disk_autoresize
  
   # disk_size = var.db_disk_size
    disk_type = var.db_disk_type
    pricing_plan = var.db_pricing_plan
    
   
    maintenance_window {
      day  = "7"  # sunday
      hour = "3" # 3am
    }
   
    backup_configuration {
      binary_log_enabled = true
      enabled = true
      start_time = "00:00"
    }
   
    ip_configuration {
      ipv4_enabled = "true"
      #Can specify public IP address range of your compute engine/GKE instances you want to connect from
      authorized_networks {
        value = var.db_instance_access_cidr
      }
    }
  }
}

# create database
resource "google_sql_database" "postgresql_db" {
  name = var.db_name
  project = var.app_project
  instance = google_sql_database_instance.postgresql.name
  charset = var.db_charset
  collation = var.db_collation
}

#DB user
resource "google_sql_user" "postgresql_user" {
  name = var.db_user_name
  project  = var.app_project
  instance = google_sql_database_instance.postgresql.name
  host = var.db_user_host
  password = var.db_user_password
}

#network
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
