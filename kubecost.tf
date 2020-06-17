resource "kubernetes_namespace" "kubecost" {
  count = var.enable_kubecost ? 1 : 0
  metadata {
    name = "kubecost"
    # labels = {
    #   istio-injection = "enabled"
    # }
  }
}

data "helm_repository" "kubecost" {
  count = var.enable_kubecost ? 1 : 0
  name  = "kubecost"
  url   = "https://kubecost.github.io/cost-analyzer/"
}

resource "helm_release" "kubecost" {
  depends_on = [helm_release.istio]
  count      = var.enable_kubecost ? 1 : 0
  name       = "kubecost"
  version    = var.kubecost_helm_chart_version
  repository = data.helm_repository.kubecost.0.name
  chart      = "cost-analyzer"
  namespace  = kubernetes_namespace.kubecost.0.metadata.0.name
  wait       = true

  values = [var.extra_kubecost_helm_values]

  set {
    name  = "kubecostToken"
    value = var.kubecost_token
  }
}
