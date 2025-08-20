output "bucket_name" {
  description = "Name of the Cloud Storage bucket"
  value       = google_storage_bucket.main.name
}

output "bucket_id" {
  description = "ID of the Cloud Storage bucket"
  value       = google_storage_bucket.main.id
}

output "bucket_url" {
  description = "URL of the Cloud Storage bucket"
  value       = google_storage_bucket.main.url
}

output "bucket_self_link" {
  description = "Self link of the Cloud Storage bucket"
  value       = google_storage_bucket.main.self_link
}

output "bucket_location" {
  description = "Location of the Cloud Storage bucket"
  value       = google_storage_bucket.main.location
}
