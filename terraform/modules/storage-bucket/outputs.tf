
output "cloud_function_bucket_name" {
  value = google_storage_bucket.cloud_function_bucket.name
}

output "input_bucket_name" {
  value = google_storage_bucket.input_bucket.name
}
