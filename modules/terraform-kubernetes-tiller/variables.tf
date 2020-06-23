variable "tiller_version" {
  type        = string
  default     = "2.14.1"
  description = "Version of Tiller to be deployed."
}

variable "tiller_namespace" {
  type        = string
  default     = "kube-system"
  description = "Namespace to deploy Tiller into."
}

variable "tiller_history_max" {
  type        = string
  default     = 50
  description = "Number of old releases to be kept by Tiller."
}

variable "tiller_service_account_name" {
  type        = string
  default     = "tiller"
  description = "Name of the service account to be created for the Tiller deployment."
}

variable "tiller_service_type" {
  type        = string
  default     = "ClusterIP"
  description = "Type of Tiller's Kubernetes service object."
}

variable "tiller_image_pull_policy" {
  type        = string
  default     = "IfNotPresent"
  description = "Default pull policy to be used for the Tiller container image."
}

variable "tolerations" {
  type        = list(map(string))
  default     = []
  description = "Tolerations to apply to Tiller deployment"
}

variable "node_selectors" {
  type        = map(string)
  default     = {}
  description = "Map of {label: value} to use as node selector for Tiller deployment"
}

variable "enable_tiller" {
  type    = bool
  default = true
  description = "Enable tiller if using Helm 2"
}
