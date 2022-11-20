resource "kubernetes_persistent_volume_claim" "wp-persistentvc" {
  metadata {
    name = "wp-persistentvc"
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

resource "kubernetes_deployment" "wp-deploy" {
  metadata {
    name = "wp-deploy"
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
            claim_name = kubernetes_persistent_volume_claim.wp-persistentvc.metadata.0.name
          }
        }


        container {
          image = "wordpress:6.1.1-apache"
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
            value = aws_db_instance.default.db_name
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
        toleration {
          effect   = "NoSchedule"
          key      = "node.kubernetes.io/master"
          operator = "Exists"
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
    kubernetes_deployment.wp-deploy
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

locals {
  lb_name = split("-", split(".", kubernetes_service.wpService.status.0.load_balancer.0.ingress.0.hostname).0).0
}

output "load_balancer_name" {
  value = local.lb_name
}

output "load_balancer_hostname" {
  value = kubernetes_service.wpService.status.0.load_balancer.0.ingress.0.hostname
}


resource "time_sleep" "wait_60_seconds" {
  create_duration = "60s"
  depends_on      = [kubernetes_service.wpService]
}


resource "null_resource" "kube_configuration" {

  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name ${var.cluster-name}"


  }
  depends_on = [kubernetes_service.wpService]
}