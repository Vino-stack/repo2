variable "gcp_project_id" {
  type = string
  description = "The project ID to create the resources in."
}

# OPTIONAL MODULE PARAMETERS
# These variables have defaults, but can be overridden 
variable "region" {
  type = string
  #default = ["us-central1"]
}

variable "zone" {
  type = string
}

variable "rins_id" {
  type = string
}

variable "redis_tire" {
  type = string
}

variable "redis_version" {
  type = string
}

variable "vpc-name" {
  type = string
}

variable "vpc-subnet" {
  type = string
}

variable "vpc-firewall" {
  type = string
}

variable "vm-machine_type" {
  type = string
  description = "Virtual machine type"
}

variable "mig-tmp-name" {
  type = string
}

variable "mig-name" {
  type = string
}

variable "external_IP_name" {
  type = string
}

variable "hc_name" {
  type = string
}

variable "lb-backend-name" {
  type = string
}

variable "fw_rule" {
  type = string
}

variable "lb-url-map" {
  type = string
}

variable "proxy-name" {
  type = string
}

variable "sql-ins-name" {
  type = string
}

variable "machine-tier" {
  type = string
}

variable "base_ins_name" {
  type = string
}

variable "mig_autoscaler" {
  type = string
}
