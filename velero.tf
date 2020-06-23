resource "kubernetes_namespace" "velero" {
  count = var.enable_velero ? 1 : 0
  metadata {
    name = var.velero_namespace_name
  }
}

# Namespace admin role
resource "kubernetes_role" "tiller-velero" {
  count = var.enable_velero ? 1 : 0
  metadata {
    name      = "tiller-velero"
    namespace = kubernetes_namespace.velero[0].metadata[0].name
  }

  # Read/write access to velero resources
  rule {
    api_groups = ["velero.io"]
    resources  = ["*"]
    verbs      = ["get", "list", "watch", "create", "update", "patch", "delete", "edit", "exec"]
  }
}

# Namespace admin role bindings
resource "kubernetes_role_binding" "tiller-velero" {
  count = var.enable_velero ? 1 : 0
  metadata {
    name      = "tiller-velero"
    namespace = kubernetes_namespace.velero[0].metadata[0].name
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "tiller-velero"
  }

  # Users
  subject {
    kind      = "ServiceAccount"
    name      = "tiller"
    namespace = kubernetes_namespace.velero[0].metadata[0].name
  }
}

resource "helm_release" "velero" {
  count      = var.enable_velero ? 1 : 0
  depends_on = [kubernetes_role.tiller-velero, kubernetes_role_binding.tiller-velero]
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
