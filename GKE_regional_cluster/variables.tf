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

