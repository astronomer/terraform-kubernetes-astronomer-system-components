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
  version    = "1.1.1"
  chart      = "cluster-autoscaler-chart"
  repository = "https://kubernetes.github.io/autoscaler"
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
