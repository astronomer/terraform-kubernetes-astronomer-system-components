resource "kubernetes_namespace" "velero" {
  count = var.enable_velero ? 1 : 0
  metadata {
    name = var.velero_namespace_name
  }
}

resource "helm_release" "velero" {
  count      = var.enable_velero ? 1 : 0
  name       = "velero"
  repository = var.velero_helm_repository
  chart      = "velero"
  version    = var.velero_helm_chart_version
  namespace  = kubernetes_namespace.velero[0].metadata[0].name
  timeout    = 1200

  values = [
    var.extra_velero_helm_values,
  ]
}
