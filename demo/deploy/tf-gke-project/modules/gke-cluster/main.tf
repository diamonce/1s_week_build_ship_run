resource "google_container_cluster" "gke_cluster" {
  provider = google-beta # This is cost optimisation measure. GKE is the MOST expensive part

  name     = var.clusterName
  location = var.region # Replace this with your desired region

  enable_shielded_nodes    = "true"
  remove_default_node_pool = true
  initial_node_count       = 1

  # Disable the Google Cloud Logging service because you may overrun the Logging free tier allocation, and it may be expensive
  logging_service = "none"

  release_channel {
    channel = "STABLE"
  }

  addons_config {
    http_load_balancing {
      disabled = false
    }
  }

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = "/16"
    services_ipv4_cidr_block = "/22"
  }

  timeouts {
    create = "20m"
    update = "20m"
  }

  lifecycle {
    ignore_changes = [node_pool]
  }


  cluster_autoscaling {
    enabled = true
    autoscaling_profile = "OPTIMIZE_UTILIZATION"
    resource_limits {
      resource_type = "cpu"
      minimum = 1
      maximum = 6
    }
    resource_limits {
      resource_type = "memory"
      minimum = 2
      maximum = 8
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.clusterName}-pool"
  location   = var.region # Replace this with your desired region
  cluster    = google_container_cluster.gke_cluster.name
#  node_count = 3

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = var.minNode
    max_node_count = var.maxNode
  }

  timeouts {
    create = "20m"
    update = "20m"
  }

  node_config {
    # More info on Spot VMs with GKE https://cloud.google.com/kubernetes-engine/docs/how-to/spot-vms#create_a_cluster_with_enabled
    spot = true
#    preemptible  = true
    machine_type = var.machineType
    disk_size_gb             = var.diskSize

    oauth_scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }

}
