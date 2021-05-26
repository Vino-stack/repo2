gcp_project_id	= "gcp-training-01-303001"
region          = "us-central1"
zone		= "us-central1-c"

rins_id = "my-redis-ins"
redis_tire ="BASIC"
redis_version ="REDIS_5_0"

vpc-name	= "vino-terraform-vpc"
vpc-subnet	= "vino-terraform-subnet"
vpc-firewall	= "vino-terraform-firewall"
vm-machine_type	= "f1-micro"
mig-tmp-name	= "vino-mig-tmp1"
mig-name	= "vino-mig"

external_IP_name = "vino-static-ip"
hc_name         = "lb-health-check"
lb-backend-name = "wp-backend"
fw_rule         = "vino-lb-fw-rule"
lb-url-map      = "lb-url-map"
proxy-name      = "lb-proxy"

machine-tier    = "db-f1-micro"
base_ins_name	= "vino-mig-ins"
mig_autoscaler	= "my-region-autoscaler"
vm_source_image = "debian-cloud/debian-9"
