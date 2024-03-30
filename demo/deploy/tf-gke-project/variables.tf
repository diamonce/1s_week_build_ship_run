variable "region" {
  description = "Deployment region for workers"
#  default = "europe-central2-c"
}
variable "region1" {
  description = "Deployment region for Master DB"
#  default = "europe-central2-c"
}
variable "region2" {
  description = "Deployment region for Slave DB"
#  default = "us-east4"
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
variable "project" {
  description = "Project Name"
#  default = "ethereal-runner-417315"  # Replace with your project Id here 
}
variable "vpc_network" {
  description = "Virtual Private Network name"
#  default = "default" # VPC Network Name to create a Private Service Connection for Cloud SQL
}