provider "google"{
  credentials="SAKEY.json"
  project =var.gcp_project_id
  region =var.region
  zone =var.zone
}
