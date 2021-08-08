provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    command     = "aws"
    args = [
      "eks",
      "get-token",
      "--cluster-name",
      data.aws_eks_cluster.cluster.name
    ]
  }
}

module "metrics_server" {
  source = "cookielab/metrics-server/kubernetes"
  version = "0.11.1"
}

resource "random_string" "csrf_token" {
  length           = 32
  special          = false
}

module "kubernetes_dashboard" {
  source = "cookielab/dashboard/kubernetes"
  version = "0.11.0"

  kubernetes_namespace_create = true
  kubernetes_dashboard_csrf = "${random_string.csrf_token.result}"
}

resource "kubernetes_deployment" "frontend" {
  metadata {
    name = "speech2text-frontend"
    labels = {
      App = "Speech2textFrontend"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "Speech2textFrontend"
      }
    }
    template {
      metadata {
        labels = {
          App = "Speech2textFrontend"
        }
      }
      spec {
        container {
          image = "efuquen/speech2text-frontend:latest"
          name  = "speech2text-frontend"

          port {
            container_port = 1323
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name = "speech2text-frontend"
  }
  spec {
    selector = {
      App = kubernetes_deployment.frontend.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 1323
    }

    type = "LoadBalancer"
  }
}

output "lb_ip" {
  value = kubernetes_service.frontend.status.0.load_balancer.0.ingress.0.hostname
}