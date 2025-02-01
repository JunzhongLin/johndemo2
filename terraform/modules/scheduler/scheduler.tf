resource "google_cloud_scheduler_job" "job" {
  provider         = google-beta
  name             = "schedule-job"
  description      = "trigger cloud run job"
  schedule         = "0 15 * * 5"
  attempt_deadline = "320s"
  region           = "europe-west1"
  project          = var.project_id
  time_zone = "Europe/Oslo"

  retry_config {
    retry_count = 3
  }

  http_target {
    http_method = "POST"
    uri         = "https://${var.region}-run.googleapis.com/apis/run.googleapis.com/v1/namespaces/${var.project_id}/jobs/${var.cloud_run_job_name}:run"

    oauth_token {
      service_account_email = var.cloud_scheduler_sa_email
    }
  }
  depends_on = [ var.cloud_run_job_depends_on ]
}
