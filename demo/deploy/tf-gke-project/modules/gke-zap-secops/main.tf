resource "google_secret_manager_secret" "zap_api_key" {
  provider = google-beta

  secret_id = "ZAP_API_KEY"

  replication {
    auto {}
  }
}

data "google_secret_manager_secret_version" "basic" {
  provider = google-beta

  secret = google_secret_manager_secret.zap_api_key.id
}

resource "google_secret_manager_secret" "zap_api_alias" {
  provider = google-beta

  secret_id = "ZAP_API_ALIAS"

  replication {
    auto {}
  }
}

data "google_secret_manager_secret_version" "alias" {
  provider = google-beta

  secret = google_secret_manager_secret.zap_api_alias.id
}

resource "kubernetes_deployment" "zap_secops_deployment" {
  metadata {
    name = "zap-secops-demo"
    labels = {
      app = "zap-secops"
    }
  }

spec {
    replicas = 1
    selector {
      match_labels = {
        app = "zap-secops"
      }
    }
    template {
      metadata {
        labels = {
          app = "zap-secops"
        }
      }
      spec {
        container {
          image = "dchernenko/zap_daemon:latest"
          name  = "dchernenko-zap-secops"
	  image_pull_policy = "Always"
          port {
            container_port = 8083
          }
	  env {
            name = "ZAP_API_KEY"
            value = data.google_secret_manager_secret_version.basic.secret_data
          }
	  env {
            name = "ZAP_API_ALIAS"
            value = data.google_secret_manager_secret_version.alias.secret_data
          }
        }
      }
    }
  }
}

resource "google_compute_firewall" "allow_only_ip" {
  name          = "k8s-fw-a8f02b31eb94f425086e82cab90cdb71"
  network       = "projects/ethereal-runner-417315/global/networks/default"
  priority      = 1000
  direction     = "INGRESS"
  target_tags   = ["gke-tf-cluster-f4bb6148-node"]
  allow {
    protocol = "tcp"
    ports    = ["8083"]
  }
  source_ranges = ["141.101.7.0/24"]  # Allow only 141.101.7.0/24 addresses
  destination_ranges = ["34.116.243.154"]  # Keep the existing destination range
  # This indicates that the existing firewall rule should be updated
  lifecycle {
    create_before_destroy = true
  }
}

resource "kubernetes_service" "zap_secops_service" {
  metadata {
    name = "zap-secops-service"
  }
  spec {
    selector = {
      app = "zap-secops"
    }
    port {
      protocol = "TCP"
      port     = 8083
      target_port = 8083
    }
    type = "LoadBalancer"
  }
}
