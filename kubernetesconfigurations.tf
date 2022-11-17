resource "kubernetes_persistent_volume_claim" "wp-pervoclaim1" {
  metadata {
    name = "wp-pervoclaim1"
    labels = {
      env     = "Production"
      Country = "Brazil"
    }
  }

  wait_until_bound = false
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }
}


resource "kubernetes_deployment" "wordp-dep" {
  metadata {
    name = "wordp-dep"
    labels = {
      env     = "Production"
      Country = "Brazil"
    }
  }
  wait_for_rollout = false

  spec {
    replicas = 2
    selector {
      match_labels = {
        pod     = "wp"
        env     = "Production"
        Country = "Brazil"

      }
    }

    template {
      metadata {
        labels = {
          pod     = "wp"
          env     = "Production"
          Country = "Brazil"
        }
      }

      spec {
        volume {
          name = "wp-vol"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.wp-pervoclaim1.metadata.0.name
          }
        }

        container {
          image = "wordpress:6.1-apache"
          name  = "wp-container"

          env {
            name  = "WORDPRESS_DB_HOST"
            value = aws_db_instance.default.endpoint
          }
          env {
            name  = "WORDPRESS_DB_USER"
            value = aws_db_instance.default.username
          }
          env {
            name  = "WORDPRESS_DB_PASSWORD"
            value = aws_db_instance.default.password
          }
          env {
            name  = "WORDPRESS_DB_NAME"
            value = aws_db_instance.default.name
          }
          env {
            name  = "WORDPRESS_TABLE_PREFIX"
            value = "wp_"
          }
          volume_mount {
            name       = "wp-vol"
            mount_path = "/var/www/html/"
          }

          port {
            container_port = 80
          }
        }
      }
    }
  }
}


resource "kubernetes_service" "wpService" {
  metadata {
    name = "wp-svc"
    labels = {
      env     = "Production"
      Country = "Brazil"
    }
  }

  depends_on = [
    kubernetes_deployment.wordp-dep
  ]

  spec {
    type = "LoadBalancer"
    selector = {
      pod = "wp"
    }

    port {
      name = "wp-port"
      port = 80
    }
  }
}

//Esperando para que o loadBalancer registra os IP'S
resource "time_sleep" "wait_60_seconds" {
  create_duration = "60s"
  depends_on      = [kubernetes_service.wpService]
}
