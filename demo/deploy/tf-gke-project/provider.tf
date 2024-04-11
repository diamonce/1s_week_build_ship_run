provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.5.1"
    }
  }
}

provider "google" {
  credentials = file("~/.config/gcloud/ethereal-runner-417315.json")
  project     = "ethereal-runner-417315"
  region      = "europe-central2-c"
}

provider "google-beta" {
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
