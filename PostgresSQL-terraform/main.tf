provider "google"{
  credentials="SAKEY.json"
  project =var.gcp_project_id
  region =var.region
  zone =var.zone
}






https://github.com/terraform-google-modules/terraform-google-sql-db/blob/master/modules/postgresql/main.tf

https://gmusumeci.medium.com/getting-started-with-terraform-and-google-cloud-platform-gcp-deploying-a-postgresql-database-ce1664fb038c

https://github.com/terraform-google-modules/terraform-google-sql-db/blob/master/examples/postgresql-ha/main.tf
