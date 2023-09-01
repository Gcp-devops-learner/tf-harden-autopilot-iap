variable "shared_vpc_host" {
  description = "Enable shared VPC for this project."
  type        = bool
  default     = false
}

variable "project_id" {
  description = "The ID of the project where this VPC will be created."
  type        = string
}

variable "shared_vpc_service_projects" {
  description = "Shared VPC service projects to register with this host."
  type        = list(string)
  default     = []
}
