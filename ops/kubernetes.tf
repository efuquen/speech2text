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