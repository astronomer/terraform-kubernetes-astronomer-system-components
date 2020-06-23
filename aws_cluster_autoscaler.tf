resource "kubernetes_namespace" "cluster_autoscaler" {
  count = var.enable_aws_cluster_autoscaler ? 1 : 0
  metadata {
    name = "cluster-autoscaler"
    labels = {
      istio-injection = "disabled"
    }
  }
}

resource "helm_release" "cluster_autoscaler" {
  count      = var.enable_aws_cluster_autoscaler ? 1 : 0
  name       = "cluster-autoscaler"
  version    = "7.3.2"
  chart      = "cluster-autoscaler"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  namespace  = kubernetes_namespace.cluster_autoscaler[0].metadata[0].name
  wait       = true

  values = [<<EOF
autoDiscovery:
  clusterName: ${var.cluster_name}
awsRegion: ${var.aws_region}
cloudProvider: aws
sslCertHostPath: /etc/kubernetes/pki/ca.crt
rbac:
  create: true
  EOF
  ]
}
