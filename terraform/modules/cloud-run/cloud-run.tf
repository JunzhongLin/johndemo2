resource "google_cloud_run_v2_job" "bq_job" {
  name     = "bq-to-pubsub-${var.env}"
  location = var.region
  deletion_protection = false

  template {
    template {
      service_account = var.cloud_run_sa_email
      containers {
        image = var.image_url
        env {
          name = "LOCATION"
          value = var.region
        }
        env {
          name = "LOCATIONS_MATERIALIZED_VIEW"
          value = var.locations_materialized_view
        }
        env {
          name = "CUSTOMERS_TABLE"
          value = var.customers_table_name
        }
        env {
          name = "PROJECT_ID"
          value = var.project_id
        }
        env {
          name = "TOPIC_NAME"
          value = var.topic_name
        }
        env {
          name = "MSG_CHUNK_SIZE"
          value = var.msg_chunk_size
        }
        resources {
          limits = {
            cpu    = "2" # TODO: pass as a variable
            memory = "1024Mi" # TODO: pass as a variable
          }
        }
      }
    }
  }
  lifecycle {
    ignore_changes = [
      launch_stage,
    ]
  }
  depends_on = [
    var.pubsub_topic_depends_on,
    var.bigquery_view_depends_on
  ]
}
