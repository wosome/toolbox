variable "project_name" {}
variable "region" {}
variable "zone" {}

data "google_compute_zones" "available" {}

resource "google_compute_instance" "default" {
  project = "${var.project_name}"
  zone = "${var.zone}"
  name = "tf-compute-1"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "ubuntu-1604-xenial-v20170328"
    }
  }
  network_interface {
    network = "default"
    access_config {
    }
  }
}

output "instance_id" {
  value = "${google_compute_instance.default.self_link}"
}
