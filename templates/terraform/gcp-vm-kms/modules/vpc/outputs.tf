output "network_self_link" {
  description = "Self link of the VPC network"
  value       = google_compute_network.main.self_link
}

output "network_id" {
  description = "ID of the VPC network"
  value       = google_compute_network.main.id
}

output "network_name" {
  description = "Name of the VPC network"
  value       = google_compute_network.main.name
}

output "subnet_self_links" {
  description = "Self links of the subnets"
  value       = google_compute_subnetwork.subnets[*].self_link
}

output "subnet_ids" {
  description = "IDs of the subnets"
  value       = google_compute_subnetwork.subnets[*].id
}

output "subnet_names" {
  description = "Names of the subnets"
  value       = google_compute_subnetwork.subnets[*].name
}

output "router_id" {
  description = "ID of the Cloud Router"
  value       = google_compute_router.router.id
}

output "nat_id" {
  description = "ID of the Cloud NAT"
  value       = google_compute_router_nat.nat.id
}
