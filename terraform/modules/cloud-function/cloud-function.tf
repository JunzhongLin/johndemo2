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

resource "google_cloudfunctions2_function" "cloud_function" {
  name                  = "Cloud-function-predict-and-send-email"
  description           = "Cloud-function will get trigger by the pubsub topic"
  project               = var.project_id
  location                = var.region
  build_config {
    runtime = "python311"
    entry_point = "main"
    source {
      storage_source {
        bucket = var.cloud_function_bucket_name
        object = google_storage_bucket_object.zip.name
      }
    }
  }
  service_config {
    max_instance_count  = 2
    available_memory    = "256M" # TODO: avoid hardcoding
    timeout_seconds     = 60
    environment_variables = {
      MODEL_BUCKET_NAME = var.model_bucket_name
      MODEL_FILE_NAME = var.model_file_name
    }
    service_account_email = var.cloud_function_sa_email
  }
  event_trigger {
    trigger_region = var.region
    event_type     = "google.cloud.pubsub.topic.v1.messagePublished"
    pubsub_topic   = var.pubsub_topic_id
    retry_policy   = "RETRY_POLICY_RETRY"
  }
  depends_on = [
    var.cloud_function_bucket_depends_on,
    google_storage_bucket_object.zip,
  ]
}
