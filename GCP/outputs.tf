# ----------------------------------------------------------
# REQUIRED OUTPUTS
# ----------------------------------------------------------
output "vpc_name" {
  description = "Name of the VPC network"
  value       = google_compute_network.cp_vpc.name
}

output "subnet_1_name" {
  description = "Name of subnet 1"
  value       = google_compute_subnetwork.cp_subnet_1.name
}

output "subnet_2_name" {
  description = "Name of subnet 2"
  value       = google_compute_subnetwork.cp_subnet_2.name
}

output "vm_instance_1_name" {
  description = "Name of the first compute instance"
  value       = google_compute_instance.cp_vm_instance.name
}

output "vm_instance_2_name" {
  description = "Name of the second compute instance"
  value       = google_compute_instance.cp_vm_instance_2.name
}

output "vm_instance_1_external_ip" {
  description = "External IP address of the first compute instance"
  value       = google_compute_instance.cp_vm_instance.network_interface[0].access_config[0].nat_ip
}

output "vm_instance_2_external_ip" {
  description = "External IP address of the second compute instance"
  value       = google_compute_instance.cp_vm_instance_2.network_interface[0].access_config[0].nat_ip
}

output "sql_instance_name" {
  description = "Name of the Cloud SQL instance"
  value       = google_sql_database_instance.cp_sql_instance.name
}

output "sql_instance_connection_name" {
  description = "Connection name of the Cloud SQL instance"
  value       = google_sql_database_instance.cp_sql_instance.connection_name
}

output "gke_cluster_name" {
  description = "Name of the GKE cluster"
  value       = google_container_cluster.cp_k8s_cluster.name
}

output "gke_cluster_endpoint" {
  description = "Endpoint of the GKE cluster"
  value       = google_container_cluster.cp_k8s_cluster.endpoint
}

