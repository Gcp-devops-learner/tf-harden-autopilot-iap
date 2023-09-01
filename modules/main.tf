resource "google_compute_shared_vpc_host_project" "shared_vpc_host" {
  provider   = google-beta
  count      = var.shared_vpc_host ? 1 : 0
  project    = var.project_id
#   depends_on = [local.network]
}

resource "google_compute_shared_vpc_service_project" "service_projects" {
  provider = google-beta
  for_each = toset(
    var.shared_vpc_host && var.shared_vpc_service_projects != null
    ? var.shared_vpc_service_projects
    : []
  )
  host_project    = var.project_id
  service_project = each.value
  depends_on      = [google_compute_shared_vpc_host_project.shared_vpc_host]
}
