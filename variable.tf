/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "project_id" {
  description = "The project ID to host the cluster in"
  type        = string
}

variable "region" {
  description = "The region the cluster in"
  default     = ""
  type        = string
}

variable "cluster_name" {
  description = "The name of the cluster (required)"
  type        = string
  default     = "gke-autopilot-private-1"

}

variable "network_name" {
  description = "The VPC network to host the cluster in (required)"
  type        = string
  default     = ""

}

variable "subnet1" {
  type        = string
    description = "The  subnets being created"
}

variable "network_project_id" {
  description = "The GCP project housing the VPC network to host the cluster in"
}

variable "pods_range_name" {
  description = "The name of the secondary subnet ip range to use for pods"
  type        = string

}
variable "svc_range_name" {
  description = "The name of the secondary subnet range to use for services"
  type        = string

}

# variable "master_authorized_networks" {
#    description =  "List of master authorized networks. If none are provided, disallow external access (except the cluster node IPs, which GKE automatically whitelists)."
#    type = list(object({ cidr_block = string, display_name = string }))
#    default = []
# } 

variable "maintenance_start_time" {
  description = "Time window specified for daily or recurring maintenance operations in RFC3339 format"
  type        = string
  default     = "2023-02-08T00:00:00Z"
}

variable "maintenance_end_time" {
  description = "Time window specified for recurring maintenance operations in RFC3339 format"
  type        = string
  default     = "2023-02-08T05:00:00Z"
}

variable "maintenance_recurrence" {
  description = "Frequency of the recurring maintenance window in RFC5545 format"
  type        = string
  default     = "FREQ=WEEKLY;BYDAY=MO,TU,WE,TH"
}

// Variables for Bastion

variable "service_account_roles" {
  type = list(string)

  description = "List of IAM roles to assign to the service account."
  default = [
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/compute.osLogin",
  ]
}

variable "bastion_members" {
  type = list(string)

  description = "List of users, groups, SAs who need access to the bastion host"
  default     = []
}

// KMS
variable "keyring" {
  description = "Keyring name."
  type        = string
}

variable "keys" {
  description = "Key names."
  type        = list(string)
  default     = []
}

###### Shared-vpc Variables


variable "service_project_id_1" {
  description = "The ID of the service project"
  type        = string
}

# variable "service_project_id_2" {
#   description = "The ID of the service project"
#   type        = string
# }

variable "host_service_account" {
  description = "The service account of the host project"
  type        = string
}

variable "service_project_account" {
  description = "The service account of the service project"
  type        = string
}




# variable "subnets" {
#   type        = list(map(string))
#   description = "The list of subnets being created"
# }



# variable "subnet2" {
#   type        = string
#     description = "The  subnets being created"
# }

# variable "subnet3" {
#   type        = string
#   description = "The  subnets being created"
# }

variable "subnet_ip1" {
  type        = string
  description = "The  subnets ip being created"
}

# variable "subnet_ip2" {
#   type        = string
#   description = "The  subnets ip being created"
# }

# variable "subnet_ip3" {
#   type        = string
#   description = "The  subnets ip being created"
# }

variable "subnets_iam" {
  type        = list(string)
  description = "The list of subnets being created"
}


#  variable "ip-range-pods-gke-autopilot-private" {
#   type = string
#   description = "Ip range pods should be mentioned"

#  }

#   variable "ip-range-service-gke-autopilot-private" {
#   type = string
#   description = "Ip range service should be mentioned"

#  }

 variable "ip_cidr_range_pods" {
  type = string
  description = "Ip range pods should be mentioned"
 }

 variable "ip_cidr_range_service" {
  type = string
  description = "Ip range service should be mentioned"
 }

# variable "secondary_ranges" {
#   type        = map(list(object({ range_name = string, ip_cidr_range = string })))
#   description = "Secondary ranges that will be used in some of the subnets"
#   default     = {}
# }

variable "routing_mode" {
  type        = string
  default     = "GLOBAL"
  description = "The network routing mode (default 'GLOBAL')"
}

variable "shared_vpc_host" {
  type        = bool
  description = "Makes this project a Shared VPC host if 'true' (default 'false')"
  default     = false
}

variable "description" {
  type        = string
  description = "An optional description of this resource. The resource must be recreated to modify this field."
  default     = ""
}

variable "auto_create_subnetworks" {
  type        = bool
  description = "When set to true, the network is created in 'auto subnet mode' and it will create a subnet for each region automatically across the 10.128.0.0/9 address range. When set to false, the network is created in 'custom subnet mode' so the user can explicitly connect subnetwork resources."
  default     = false
}

variable "delete_default_internet_gw" {
  type        = bool
  description = "If set, ensure that all routes within the network specified whose names begin with 'default-route' and with a next hop of 'default-internet-gateway' are deleted"
  default     = true
}

variable "mtu" {
  type        = number
  description = "The network MTU. Must be a value between 1460 and 1500 inclusive. If set to 0 (meaning MTU is unset), the network will default to 1460 automatically."
  default     = 0
}
   


variable "rules" {
  description = "List of custom rule definitions (refer to variables file for syntax)."
  default     = []
  type = list(object({
    name                    = string
    description             = string
    direction               = string
    priority                = number
    ranges                  = list(string)
    source_tags             = list(string)
    source_service_accounts = list(string)
    target_tags             = list(string)
    target_service_accounts = list(string)
    allow = list(object({
      protocol = string
      ports    = list(string)
    }))
    deny = list(object({
      protocol = string
      ports    = list(string)
    }))
    log_config = object({
      metadata = string
    })
  }))
}


