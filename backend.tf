terraform {
  backend "gcs" {
    bucket = "kineton-gke-foundation"
    prefix = "terraform/state/"
  }
}