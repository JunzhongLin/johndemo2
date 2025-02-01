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
