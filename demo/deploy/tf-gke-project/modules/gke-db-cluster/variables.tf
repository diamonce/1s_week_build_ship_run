variable "region1" {
  description = "Deployment region for Master"
  default = "europe-central2-c"
}

variable "region2" {
  description = "Deployment region for Slave"
  default = "us-east4"
}

variable "project" {
    default = "ethereal-runner-417315"  # Replace with your project Id here
}

variable "vpc_network" {
   default = "default" # VPC Network Name to create a Private Service Connection for Cloud SQL
}
