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



data "google_client_config" "default" {}


# provider "kubernetes" {
#   host                   = "https://${module.gke.endpoint}"
#   token                  = data.google_client_config.default.access_token
#   cluster_ca_certificate = base64decode(module.gke.ca_certificate)
# }



// Private GKE Autopilot Module
module "gke" {
  source                          = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster"
  project_id                      = var.project_id
  name                            = var.cluster_name
  network_project_id              = var.network_project_id
  regional                        = true
  region                          = var.region
  network                         = var.network_name
  subnetwork                      = var.subnet1
  ip_range_pods                   = var.pods_range_name
  ip_range_services               = var.svc_range_name
  release_channel                 = "RAPID"
  maintenance_start_time          = var.maintenance_start_time
  maintenance_end_time            = var.maintenance_end_time
  maintenance_recurrence          = var.maintenance_recurrence
  enable_vertical_pod_autoscaling = true
  enable_private_endpoint         = true
  enable_private_nodes            = true
  grant_registry_access           = true
  master_ipv4_cidr_block          = "172.10.0.0/28"
  master_authorized_networks = [{
    cidr_block   = "${module.bastion.ip_address}/32"
    display_name = "Bastion Host"
  }]
  database_encryption = [
    {
      "key_name" : module.kms.keys[var.keys[0]],
      "state" : "ENCRYPTED"
    }
  ]
  depends_on = [module.enabled_google_apis, module.subnet-iam-bindings]
  
}
