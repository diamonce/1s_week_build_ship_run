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

module "gke_dok_tele_status" {
  source = "./modules/gke-dok-tele-status"

  region       = var.region
  clusterName  = var.clusterName
  diskSize     = var.diskSize
  minNode      = var.minNode
  maxNode      = var.maxNode
  machineType  = var.machineType
}

module "gke_db_cluster" {
  source = "./modules/gke-db-cluster"

  region1       = var.region1
  region2       = var.region2
  vpc_network   = var.vpc_network
  project       = var.project
}

module "gke_zap_secops" {
  source = "./modules/gke-zap-secops"

  region       = var.region
  clusterName  = var.clusterName
  diskSize     = var.diskSize
  minNode      = var.minNode
  maxNode      = var.maxNode
  machineType  = var.machineType
}

module "gke_argocd" {
  source = "./modules/gke-argocd"

  region       = var.region
  clusterName  = var.clusterName
  diskSize     = var.diskSize
  minNode      = var.minNode
  maxNode      = var.maxNode
  machineType  = var.machineType
}
