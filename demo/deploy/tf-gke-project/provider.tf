provider "google" {
  credentials = file("~/.config/gcloud/ethereal-runner-417315.json")
  project     = "ethereal-runner-417315"
  region      = "europe-central2-c"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "null_resource" "update_kubeconfig" {
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials tf-cluster --region europe-central2-c --project ethereal-runner-417315"
  }
}
