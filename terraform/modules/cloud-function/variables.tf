variable "project_id" {
  type    = string
}

variable "region" {
  type    = string
}

variable "cloud_function_bucket_name" {
  type = string
}

variable "input_bucket_name" {
  type = string
}

variable "cloud_function_bucket_depends_on" {
  type    = any
  default = []
}

variable "model_bucket_name" {
  type    = string
}

variable "model_file_name" {
  type    = string
}

variable "cloud_function_sa_email" {
  type    = string
}

variable "pubsub_topic_id" {
  type    = string
}
