terraform {
  backend "gcs" {
    bucket  = "${TF_PROJECT_ID}"
    prefix  = "terraform/state"
  }
}
