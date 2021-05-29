# define GCP project name
variable "app_project" {
  type = string
  description = "GCP project name"
}
# define GCP region
variable "gcp_region_1" {
  type = string
  description = "GCP region"
}

variable db_version {
  description = "The version of of the database. For example,
    POSTGRES_9_6 or POSTGRES_11"
  default = "POSTGRES_11"
}
variable db_tier {
  description = "The machine tier (First Generation) or type (Second
    Generation). Reference: https://cloud.google.com/sql/pricing"
  default = "db-f1-micro"
}
variable db_activation_policy {
  description = "Specifies when the instance should be active.
    Options are ALWAYS, NEVER or ON_DEMAND"
  default = "ALWAYS"
}
variable db_disk_autoresize {
  description = "Second Generation only. Configuration to increase
    storage size automatically."
  default = true
}

variable db_disk_type {
  description = "Second generation only. The type of data disk:
    PD_SSD or PD_HDD"
  default = "PD_SSD"
}

variable db_instance_access_cidr {
  description = "The IPv4 CIDR to provide access the database
    instance"
  default = "0.0.0.0/0"
}
# database settings
variable db_name {
  description = "Name of the default database to create"
  default = "tfdb"
}
variable db_charset {
  description = "The charset for the default database"
  default = ""
}
variable db_collation {
  description = "The collation for the default database. Example for
    MySQL databases: 'utf8_general_ci'"
  default = ""
}
# user settings
variable db_user_name {
  description = "The name of the default user"
  default = "dbadmin"
}
variable db_user_host {
  description = "The host for the default user"
  default = "%"
}
variable db_user_password {
  description = "The password for the default user"
  default = "mypass"
}
