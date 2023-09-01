locals {
  service_project_1 = {
    service_project_id_1   = var.service_project_id_1 
  }
#   service_project_2 = {
#     service_project_id_2 = var.service_project_id_2 
#   }
  host_service_account_1 = var.host_service_account

  service_project_account_1 =var.service_project_account

}

module "vpc-host" {
  source     = "./modules"
  depends_on = [module.vpc, module.firewall_rules]
  project_id = var.network_project_id   
  shared_vpc_host = true
  shared_vpc_service_projects = [
    local.service_project_1.service_project_id_1 ,
    # local.service_project_2.service_project_id_2
  ]
  
}

module "vpc"  {
    source  = "terraform-google-modules/network/google"
    version = "~> 7.3"

 

    project_id   = var.network_project_id   
    network_name = var.network_name
    routing_mode = "GLOBAL"

 

    subnets = [
        {
            subnet_name           = var.subnet1
            subnet_ip             = var.subnet_ip1
            subnet_region         = var.region
        }
    ]
 

    secondary_ranges = {
        milan-subnet-01 = [
            {
                range_name    = var.pods_range_name
                ip_cidr_range =  var.ip_cidr_range_pods 
            },
            {
                range_name    = var.svc_range_name
                ip_cidr_range = var.ip_cidr_range_service      
            },
        ]

        subnet-02 = []
    }

}


module "firewall_rules" {
  source       = "terraform-google-modules/network/google//modules/firewall-rules"
  depends_on = [module.vpc]
  project_id   = var.network_project_id   
  network_name = module.vpc.network_name

  rules = [{
    name                    = "allow-ssh-ingress"
    description             = null
    direction               = "INGRESS"
    priority                = null
    destination_ranges      = ["10.0.0.0/8"]
    source_ranges           = ["0.0.0.0/0"]
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
}


module "subnet-iam-bindings" {
  source = "terraform-google-modules/iam/google//modules/subnets_iam"
  depends_on = [module.vpc-host]
  subnets        = var.subnets_iam 
  subnets_region = var.region
  project        = var.network_project_id   
  mode           = "authoritative"
  bindings = {
    "roles/compute.networkUser" = [
        local.host_service_account_1,
        local.service_project_account_1
        
    #   "group:my-group@my-org.com",
    #   "user:my-user@my-org.com",
    ]
    # "roles/compute.networkViewer" = [
    #   "serviceAccount:my-sa@my-project.iam.gserviceaccount.com",
    #   "group:my-group@my-org.com",
    #   "user:my-user@my-org.com",
    # ]
  }
#   conditional_bindings = [
#     {
#       role = "roles/compute.networkAdmin"
#       title = "expires_after_2019_12_31"
#       description = "Expiring at midnight of 2019-12-31"
#       expression = "request.time < timestamp(\"2020-01-01T00:00:00Z\")"
#       members = ["user:my-user@my-org.com"]
#     }
#   ]
}



