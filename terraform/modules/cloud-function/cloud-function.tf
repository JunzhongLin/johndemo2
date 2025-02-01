data "archive_file" "source" {
  type        = "zip"
  source_dir  = "${path.root}/../src/cloud_function"
  output_path = "${path.root}/function.zip"
}

resource "google_storage_bucket_object" "zip" {
  source       = data.archive_file.source.output_path
  content_type = "application/zip"
  name         = "src-${data.archive_file.source.output_md5}.zip"
  bucket       = var.cloud_function_bucket_name
  depends_on = [
    var.cloud_function_bucket_depends_on,
    data.archive_file.source
  ]
}

resource "google_cloudfunctions_function" "cloud_function" {
  name                  = "Cloud-function-trigger-using-terraform"
  description           = "Cloud-function will get trigger once file is uploaded in ${var.input_bucket_name}"
  runtime               = "python39"
  project               = var.project_id
  region                = var.region
  source_archive_bucket = var.cloud_function_bucket_name
  source_archive_object = google_storage_bucket_object.zip.name
  entry_point           = "fileUpload"
  event_trigger {
    event_type = "google.storage.object.finalize"
    resource   = var.input_bucket_name
  }
  depends_on = [
    var.cloud_function_bucket_depends_on,
    google_storage_bucket_object.zip,
  ]
}
