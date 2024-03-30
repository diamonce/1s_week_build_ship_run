terraform {
  backend "gcs" {
    bucket = "ethereal-runner-417315-tfstate" ## replace with a GCS bucket name
    prefix = "tfsql/"
  }
}

resource "google_secret_manager_secret" "db-user-name" {
  provider = google-beta
      
  secret_id = "DB_USER_NAME"
	
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "db-pass" {
  provider = google-beta
      
  secret_id = "DB_PASS"
	
  replication {
    auto {}
  }
}

resource "google_secret_manager_secret" "db-name" {
  provider = google-beta
      
  secret_id = "DB_NAME"
	
  replication {
    auto {}
  }
}

data "google_secret_manager_secret_version" "db-user-name" {
  provider = google-beta

  secret = google_secret_manager_secret.db-user-name.id
}

data "google_secret_manager_secret_version" "db-name" {
  provider = google-beta

  secret = google_secret_manager_secret.db-name.id
}

data "google_secret_manager_secret_version" "db-pass" {
  provider = google-beta

  secret = google_secret_manager_secret.db-pass.id
}

resource "random_id" "db_name_suffix_master" {
  byte_length = 2
}

resource "random_id" "db_name_suffix_replica" {
  byte_length = 2
}

# Use DB VPC Network
#
resource "google_compute_network" "private_network" {
  name                    = var.vpc_network
  project                 = var.project
  auto_create_subnetworks = false
}

#data "google_compute_network" "default" {
#  name = var.vpc_network
#}

resource "google_compute_global_address" "private_ip_address" {
  name          = google_compute_network.private_network.name
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.private_network.name
  project       = var.project
}

resource "google_service_networking_connection" "default" {
  network                 = google_compute_network.private_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

resource "google_sql_database_instance" "master" {
  name             = "tf-cluster-db-${random_id.db_name_suffix_master.hex}"
  region           = var.region1
  database_version = "POSTGRES_11"
  project          = var.project
  depends_on =    [google_service_networking_connection.default]
  deletion_protection = false
  settings {
    tier              = "db-f1-micro"
    availability_type = "REGIONAL"
    disk_size         = "100"
    backup_configuration {
      enabled = true
    }
    ip_configuration {
      ipv4_enabled    = true
      private_network = "projects/${var.project}/global/networks/${var.vpc_network}"
    }
  }
}

resource "google_sql_database_instance" "read_replica" {
  name                 = "tf-cluster-db-${random_id.db_name_suffix_replica.hex}"
  master_instance_name = "${google_sql_database_instance.master.name}"
  region               = var.region2
  database_version     = "POSTGRES_11"
  project              = var.project
  deletion_protection = false
  replica_configuration {
    failover_target = false
  }
  depends_on =    [google_service_networking_connection.default]
  settings {
    tier              = "db-f1-micro"
    availability_type = "REGIONAL"
    disk_size         = "100"
    backup_configuration {
      enabled = false
    }
    ip_configuration {
      ipv4_enabled    = true
      private_network = "projects/${var.project}/global/networks/${var.vpc_network}"
    }
  }
}

resource "google_sql_user" "users" {
  name     = data.google_secret_manager_secret_version.db-user-name.secret_data
  instance = google_sql_database_instance.master.name
  password = data.google_secret_manager_secret_version.db-pass.secret_data
}

resource "google_sql_database" "database" {
  name     = data.google_secret_manager_secret_version.db-name.secret_data
  instance = google_sql_database_instance.master.name
}

# Define the default VPC network
data "google_compute_network" "default" {
  name = "default"
}

# Define the database VPC network
data "google_compute_network" "db-vpc-net" {
  name = "db-vpc-net"
}

# Define VPC network peering from default network to database network
resource "google_compute_network_peering" "default_to_db" {
  name                  = "default-to-db-peering"
  network               = data.google_compute_network.default.self_link
  peer_network          = data.google_compute_network.db-vpc-net.self_link
  export_custom_routes  = false  # Set to true if you want to export custom routes
  import_custom_routes  = false  # Set to true if you want to import custom routes
}

# Define firewall rule to allow PostgreSQL connections from GKE cluster
resource "google_compute_firewall" "allow_postgres_from_gke" {
  name    = "allow-postgres-from-gke"
  network = data.google_compute_network.db-vpc-net.name
  
  allow {
    protocol = "tcp"
    ports    = ["5432"]
  }
  
  source_tags      = ["tf-cluster"]  # Assuming GKE nodes have this tag
  source_ranges    = ["10.30.0.0/16"] # Replace with GKE cluster CIDR range
  target_tags      = ["tf-cluster-db"] # Assuming database server VMs have this tag
}
