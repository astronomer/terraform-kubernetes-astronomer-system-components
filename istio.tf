resource "kubernetes_namespace" "istio_system" {
  count = var.enable_istio == "true" ? 1 : 0
  metadata {
    name = "istio-system"
  }
}

# Upgrade is better supported using a local chart
# https://istio.io/docs/setup/kubernetes/#downloading-the-release
# https://istio.io/docs/setup/kubernetes/upgrade/steps/
resource "null_resource" "helm_repo" {

  provisioner "local-exec" {
    command = <<EOF
    set -xe
    cd ${path.root}
    rm -rf ./istio-${var.istio_helm_release_version} || true
    curl -L https://git.io/getLatestIstio | ISTIO_VERSION=${var.istio_helm_release_version} sh -
    rm -rf ./istio || true
    mv ./istio-${var.istio_helm_release_version} istio
    EOF
  }

  triggers = {
    build_number = timestamp()
  }
}

resource "helm_release" "istio_init" {
  depends_on   = [module.tiller, null_resource.helm_repo]
  count        = var.enable_istio == "true" ? 1 : 0
  name         = "istio-init"
  chart        = "./istio/install/kubernetes/helm/istio-init"
  namespace    = kubernetes_namespace.istio_system[0].metadata[0].name
  wait         = true
  version      = var.istio_helm_release_version
  force_update = true
  # give istio_init time to set up
  provisioner "local-exec" {
    command = "sleep ${var.sleep_for_after_istio_init}"
  }
}

resource "helm_release" "istio" {
  depends_on = [helm_release.istio_init, null_resource.helm_repo]
  count      = var.enable_istio == "true" ? 1 : 0
  name       = "istio"
  chart      = "./istio/install/kubernetes/helm/istio"
  namespace  = kubernetes_namespace.istio_system[0].metadata[0].name
  version    = var.istio_helm_release_version
  wait       = true

  values = [
    var.extra_istio_helm_values,
  ]

  dynamic "set" {
    for_each = var.istio_local_development ? map("gateways.istio-ingressgateway.type", "NodePort") : {}
    content {
      name  = set.key
      value = set.value
    }
  }

}

resource "helm_release" "istio_local_gatewaty" {
  depends_on = [helm_release.istio, null_resource.helm_repo]
  count      = var.enable_istio_local_gateway ? 1 : 0
  name       = "istio"
  chart      = "./istio/install/kubernetes/helm/istio"
  namespace  = kubernetes_namespace.istio_system[0].metadata[0].name
  version    = var.istio_helm_release_version
  wait       = true

  values = [local.istio_local_gateway_helm_values]

  dynamic "set" {
    for_each = var.enable_istio_local_gateway ? local.istio_local_gateway_helm_set_list : {}
    content {
      name  = set.key
      value = set.value
    }
  }
}
