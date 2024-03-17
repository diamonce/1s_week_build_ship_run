module "gke_cluster" {
  source = "./modules/gke-cluster"

  region       = var.region
  clusterName  = var.clusterName
  diskSize     = var.diskSize
  minNode      = var.minNode
  maxNode      = var.maxNode
  machineType  = var.machineType
}

module "gke_demo_app" {
  source = "./modules/gke-demo-app"

  region       = var.region
  clusterName  = var.clusterName
  diskSize     = var.diskSize
  minNode      = var.minNode
  maxNode      = var.maxNode
  machineType  = var.machineType
}
