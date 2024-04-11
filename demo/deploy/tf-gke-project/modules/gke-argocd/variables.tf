variable "region" {
  description = "Deployment region"
  default = "europe-central2-c"
}
variable "clusterName" {
  description = "Name of our Cluster"
}
variable "diskSize" {
  description = "Node disk size in GB"
}
variable "minNode" {
  description = "Minimum Node Count"
}
variable "maxNode" {
  description = "maximum Node Count"
}
variable "machineType" {
  description = "Node Instance machine type"
}
