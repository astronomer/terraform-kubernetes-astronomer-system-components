module tiller {
  source             = "./modules/terraform-kubernetes-tiller"
  tiller_version     = var.tiller_version
  tiller_history_max = 5
  tolerations        = var.tiller_tolerations
  node_selectors     = var.tiller_node_selectors
  enable_tiller      = var.enable_tiller
}
