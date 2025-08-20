output "instance_id" {
  description = "ID of the Compute Engine instance"
  value       = google_compute_instance.main.id
}

output "instance_name" {
  description = "Name of the Compute Engine instance"
  value       = google_compute_instance.main.name
}

output "external_ip" {
  description = "External IP address of the Compute Engine instance"
  value       = google_compute_instance.main.network_interface[0].access_config[0].nat_ip
}

output "internal_ip" {
  description = "Internal IP address of the Compute Engine instance"
  value       = google_compute_instance.main.network_interface[0].network_ip
}

output "self_link" {
  description = "Self link of the Compute Engine instance"
  value       = google_compute_instance.main.self_link
}

output "service_account_email" {
  description = "Email of the service account attached to the instance"
  value       = google_service_account.compute_sa.email
}

output "service_account_id" {
  description = "ID of the service account attached to the instance"
  value       = google_service_account.compute_sa.id
}
