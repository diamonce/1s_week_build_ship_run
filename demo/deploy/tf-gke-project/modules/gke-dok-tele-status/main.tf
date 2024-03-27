resource "google_secret_manager_secret" "tele-token" {
  provider = google-beta
      
  secret_id = "TELE_TOKEN"
	
  replication {
    auto {}
  }
}

data "google_secret_manager_secret_version" "basic" {
  provider = google-beta

  secret = google_secret_manager_secret.tele-token.id
}

resource "kubernetes_deployment" "dok_tele_status_deployment" {
  metadata {
    name = "dok-tele-status-demo"
      labels = {
        app = "dok-tele-status"
      }
 }
  spec {
    replicas = 1
      selector {
        match_labels = {
          app = "dok-tele-status"
        }
      }
    template {
      metadata {
        labels = {
          app = "dok-tele-status"
        }
      }
      spec {
        container {
          image = "dchernenko/dok_tele_status:production"
          name  = "dok-tele-status"
	  image_pull_policy = "Always"

	        env {
	          name = "TELE_TOKEN"
	          value = data.google_secret_manager_secret_version.basic.secret_data
          }
        }
      }
    }
  }
}
