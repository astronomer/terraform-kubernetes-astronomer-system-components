resource "kubernetes_namespace" "astronomer" {
  metadata {
    name = var.astronomer_namespace
    labels = {
      istio-injection = "enabled"
      name            = "astronomer"
    }
  }
}
