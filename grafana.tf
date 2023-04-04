resource "helm_release" "grafana" {
  count = var.grafana_enabled ? 1 : 0

  chart            = "grafana"
  name             = "grafana"
  namespace        = "grafana"
  create_namespace = true
  repository       = "https://grafana.github.io/helm-charts"

  values = [
    templatefile("${path.module}/grafana.yml", {
      GOOGLE_CLIENT_ID     = var.grafana_google_auth_client_id
      GOOGLE_CLIENT_SECRET = var.grafana_google_auth_client_secret
    }),
  ]

  set {
    name  = "ingress.enabled"
    value = var.grafana_ingress_enabled
  }

  set {
    name  = "persistence.enabled"
    value = var.grafana_persistence_storage
  }

  dynamic "set" {
    for_each = var.grafana_ingress_enabled != false ? [1] : []
    content {
      name  = "ingress.hosts"
      value = yamlencode(var.grafana_ingress_hosts)
    }
  }
}
