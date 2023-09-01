
project_id                   = "service-project1-367504"
network_project_id           = "km1-runcloud"
region                       = "europe-west8" 
cluster_name                 = "gke-cluster-terraform"
network_name                 = "shared-vpc-kamp-project"
subnet1                       = "milan-subnet-01"
pods_range_name              = "ip-range-pods-gke-autopilot-private"
svc_range_name               = "ip-range-service-gke-autopilot-private"
master_authorized_networks=[
    {
      cidr_block   = "10.60.0.0/17"
      display_name = "VPC"
    },
  ]

service_account_roles  = [
  "roles/resourcemanager.projectIamAdmin",
  "roles/iam.serviceAccountUser",
  "roles/compute.viewer",
  "roles/container.developer"
]

bastion_members = [
    "serviceAccount:sricharank-km1-runcloud-iam-gs@km1-runcloud.iam.gserviceaccount.com",
  ]

keys            = ["gke-key"]
keyring         = "gke-etcd01-ring"




### shared_vpc variables values



host_service_account = "serviceAccount:sricharank-km1-runcloud-iam-gs@km1-runcloud.iam.gserviceaccount.com"

service_project_account = "user:baljeet@baljeetkaursce.joonix.net"

service_project_id_1 = "service-project1-367504"

# service_project_id_2 = "baljeetsce1"

delete_default_internet_gw = "true"


subnets_iam = [
    "milan-subnet-01"
]

subnet_ip1 = "10.0.0.0/24"



ip_cidr_range_pods = "192.168.64.0/24"

ip_cidr_range_service = "172.16.1.0/28"



rules = [{
    name                    = "firewall-allow-ssh-ingress"
    description             = null
    direction               = "INGRESS"
    priority                = null
    ranges                  = ["0.0.0.0/0"]
    source_tags             = null
    source_service_accounts = null
    target_tags             = null
    target_service_accounts = null
    allow = [{
      protocol = "tcp"
      ports    = ["22"]
    }]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
  }]