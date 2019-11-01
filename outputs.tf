# https://github.com/hashicorp/terraform/issues/1178
resource "null_resource" "dependency_setter" {
  # make sure that the role binding is present
  # before proceeding
  depends_on = [module.tiller,
    kubernetes_namespace.astronomer,
    helm_release.istio,
    helm_release.knative,
  ]
}
output "depended_on" {
  value = "${null_resource.dependency_setter.id}-${timestamp()}"
}
