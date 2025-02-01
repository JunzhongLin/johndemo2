
resource "google_bigquery_table" "locations_materialized_view" {

  dataset_id = var.dataset_id
  table_id   = var.table_id

  materialized_view {
    query = var.query
  }

}
