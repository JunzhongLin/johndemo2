variable image_url {
  type = string
}

variable "project_id" {
  type    = string
}

variable "region" {
  type    = string
}

variable "env" {
  type    = string
}

variable "customers_table_name" {
  type    = string
}

variable "msg_chunk_size" {
  type    = number
}
variable locations_materialized_view {
  type = string
}
variable topic_name {
  type = string
}
variable bigquery_view_depends_on {
  type = any
}
variable pubsub_topic_depends_on {
  type = any
}
variable "cloud_run_sa_email" {
  type = string
}
