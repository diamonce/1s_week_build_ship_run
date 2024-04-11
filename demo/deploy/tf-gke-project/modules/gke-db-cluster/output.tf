
#output "db_replica_instance_name" {
#  description = "The name for Cloud SQL instance"
#  value       = google_sql_database_instance.read_replica.name
#}

output "db_master_instance_name" {
  description = "The name for Cloud SQL instance"
  value       = google_sql_database_instance.master.name
}

#output "db_replica_region" {
#  description = "The name for Cloud SQL instance"
#  value       = google_sql_database_instance.read_replica.region
#}

output "db_master_region" {
  description = "The name for Cloud SQL instance"
  value       = google_sql_database_instance.master.region
}
