# terraform {
#   backend "gcs" {}
# }

module "storage_bucket" {
  source     = "./modules/storage-bucket"
  project_id = var.project_id
  region     = var.region
}

module "cloud_function" {
  source                           = "./modules/cloud-function"
  project_id                       = var.project_id
  region                           = var.region
  cloud_function_bucket_name       = module.storage_bucket.cloud_function_bucket_name
  input_bucket_name                = module.storage_bucket.input_bucket_name
  cloud_function_bucket_depends_on = [module.storage_bucket.cloud_function_bucket_name]
  model_bucket_name                = var.model_bucket_name
  model_file_name                  = var.model_file_name
  cloud_function_sa_email          = module.service_account.cloud_function_sa_email
  pubsub_topic_id                  = module.pubsub.msg_input_topic_id
}

module "pubsub" {
  source = "./modules/pubsub"
}

module "bigquery" {
  source     = "./modules/bigquery"
  dataset_id = var.dataset_id
  table_id   = var.locations_view_name
  query      = var.query
}

module "cloud_run" {
  source                      = "./modules/cloud-run"
  region                      = var.region
  locations_materialized_view = "${var.project_id}.${var.dataset_id}.${var.locations_view_name}"
  topic_name                  = module.pubsub.msg_input_topic_name
  customers_table_name        = "${var.project_id}.${var.dataset_id}.${var.customers_table_name}"
  msg_chunk_size              = var.msg_chunk_size
  env                         = var.env
  image_url                   = var.image_url
  project_id                  = var.project_id
  bigquery_view_depends_on    = [module.bigquery.locations_materialized_view]
  pubsub_topic_depends_on     = [module.pubsub.msg_input_topic_name]
  cloud_run_sa_email          = module.service_account.cloud_run_sa_email
}

module "scheduler" {
  source                   = "./modules/scheduler"
  project_id               = var.project_id
  region                   = var.region
  cloud_run_job_name       = module.cloud_run.cloud_run_job_name
  cloud_scheduler_sa_email = module.service_account.cloud_scheduler_sa_email
  cloud_run_job_depends_on = [module.cloud_run.cloud_run_job_name]
}

module "service_account" {
  source     = "./modules/service_account"
  project_id = var.project_id
}
