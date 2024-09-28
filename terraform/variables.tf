variable "aws_region" {
  type        = string
  description = "(Optional) AWS Region to deploy in. Defaults to us-east-1."
  default     = "us-east-1"
}

variable "aws_access_key_id" {
  type        = string
  description = "(Required) AWS_ACCESS_KEY_ID"
}

variable "aws_secret_access_key" {
  type        = string
  description = "(Required) AWS_SECRET_ACCESS_KEY"
}

variable "aws_session_token" {
  type        = string
  description = "(Required) AWS_SESSION_TOKEN"
}

variable "project_name" {
  type        = string
  description = "(Required) Name of the project."
  default     = "kithomak-cloud-project-1"
}