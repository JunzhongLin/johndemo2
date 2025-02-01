variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "cloud_run_job_name" {
  type = string
}

variable "cloud_scheduler_sa_email" {
  type = string
}

variable "cloud_run_job_depends_on" {
  type = any
}
