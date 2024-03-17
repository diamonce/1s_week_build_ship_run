resource "kubernetes_deployment" "go_deployment" {
  metadata {
    name = "go-demo"
    labels = {
      app = "go"
    }
  }

spec {
    replicas = 3
    selector {
      match_labels = {
        app = "go"
      }
    }
    template {
      metadata {
        labels = {
          app = "go"
        }
      }
      spec {
        container {
          image = "dchernenko/demo_app:latest"
          name  = "dchernenko-demo-app"
          port {
            container_port = 8088
          }
        }
      }
    }
  }
}
resource "kubernetes_service" "go_service" {
  metadata {
    name = "go-service"
  }
  spec {
    selector = {
      app = "go"
    }
    port {
      protocol = "TCP"
      port     = 80
      target_port = 8088
    }
    type = "LoadBalancer"
  }
}
