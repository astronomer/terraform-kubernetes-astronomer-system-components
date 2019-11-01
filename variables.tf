variable "enable_istio" {
  default = "false"
  type    = string
}

variable "sleep_for_after_istio_init" {
  default = "10"
  type    = string
}

# https://cloud.google.com/sql/docs/postgres/
variable "enable_cloud_sql_proxy" {
  default     = false
  type        = string
  description = "A GCP feature for secure communication with Cloud SQL"
}

variable "enable_aws_cluster_autoscaler" {
  default     = false
  type        = string
  description = "Automatically scale out node pool(s) on AWS. Must set var.cluster_name"
}

variable "cluster_name" {
  default     = ""
  type        = string
  description = "Used only with var.enable_aws_cluster_autoscaler"
}

variable "aws_region" {
  default     = "us-east-1"
  type        = string
  description = "Used only with var.enable_aws_cluster_autoscaler"
}

variable "cloudsql_instance" {
  default     = ""
  type        = string
  description = "Used when enable_cloud_sql_proxy is true"
}

variable "gcp_region" {
  default     = ""
  type        = string
  description = "Used when enable_cloud_sql_proxy is true"
}

variable "gcp_project" {
  default     = ""
  type        = string
  description = "Used when enable_cloud_sql_proxy is true"
}

variable "gcp_service_account_key_json" {
  default     = ""
  type        = string
  description = "Used when enable_cloud_sql_proxy is true"
}

variable "istio_helm_release_version" {
  default = "1.3.0"
  type    = string
}

variable "tiller_version" {
  default = "2.14.1"
  type    = string
}

variable "tiller_namespace" {
  default = "kube-system"
  type    = string
}

variable "astronomer_namespace" {
  default = "astronomer"
  type    = string
}

# https://github.com/hashicorp/terraform/issues/1178
resource "null_resource" "dependency_getter" {
  triggers = {
    my_dependencies = join(",", var.dependencies)
  }
}
variable "dependencies" {
  default = [""]
  type    = list(string)
}

variable "extra_istio_helm_values" {
  type        = "string"
  description = "Values in raw yaml to pass to helm to override defaults in Istio Helm Chart."
  default     = ""
}

variable "extra_googlesqlproxy_helm_values" {
  type        = "string"
  description = "Values in raw yaml to pass to helm to override defaults in Google SQL Proxy Helm Chart."
  default     = ""
}

variable "extra_kubecost_helm_values" {
  type        = "string"
  description = "Values in raw yaml to pass to helm to override defaults in the Kubecost Helm Chart."
  default     = ""
}

variable "kubecost_helm_chart_version" {
  default     = "1.44.3"
  type        = string
  description = "The helm chart version of Kubecost. Versions can be found here https://github.com/kubecost/cost-analyzer-helm-chart/releases"
}

variable "kubecost_token" {
  default     = ""
  type        = string
  description = "A user token for Kubecost, obtained from the Kubecost organization. Can be obtained by providing email here https://kubecost.com/install"
}

variable "enable_kubecost" {
  default = false
  type    = bool
}

variable "enable_velero" {
  default = false
  type    = bool
}

variable "extra_velero_helm_values" {
  type        = "string"
  default     = ""
  description = "Vales in raw yaml to pass to helm to helm to override defaults in Velero Helm Chart."
}

variable "velero_namespace_name" {
  default     = "velero"
  description = "Namespace to create to install Velero"
}

variable "velero_helm_repository" {
  default     = "stable"
  description = "Helm repository to use to download velero chart"
}

variable "velero_helm_chart_version" {
  default     = "2.1.6"
  description = "Helm Chart Version to use to deploy Velero"
}

variable "tiller_tolerations" {
  type        = list(map(string))
  default     = []
  description = "Tolerations to apply to Tiller deployment"
}

variable "tiller_node_selectors" {
  type        = map(string)
  default     = {}
  description = "Map of {label: value} to use as node selector for Tiller deployment"
}

variable "enable_knative" {
  type        = bool
  default     = false
  description = "enable_istio=true is required for knative to work"
}

variable "knative_helm_release_version" {
  default     = "0.1.0"
  description = "Helm Chart Version to use to deploy Knative"
}
