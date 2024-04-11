data "google_secret_manager_secret" "tele-token" {
  provider = google-beta

  secret_id = "TELE_TOKEN"
}

data "google_secret_manager_secret_version" "basic" {
  provider = google-beta

  secret = data.google_secret_manager_secret.tele-token.id
}

resource "helm_release" "argocd" {
  name             = "argocd-service"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "3.35.4"
  values = [
    templatefile("${path.module}/values.yaml", {
      TELE_TOKEN = "${data.google_secret_manager_secret_version.basic.secret_data}",
    })
  ]
}

resource "kubernetes_service" "argocd_service" {
  metadata {
    name = "argocd-service-server-lb"
    namespace = "argocd"
  }
  spec {
    selector = {
      "app.kubernetes.io/name" = "argocd-server"
    }
    port {
      protocol = "TCP"
      port     = 8089
      target_port = 8080
    }
    type = "LoadBalancer"
  }
}
