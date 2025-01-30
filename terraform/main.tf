terraform {
  backend "gcs" {}
}

variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "repo_name" {
  type = string
}

variable "env" {
  type = string
}

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
}
