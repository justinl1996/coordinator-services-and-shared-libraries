# Copyright 2023 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

variable "aws_region" {
  description = "AWS region where to deploy resources."
  type        = string
}

variable "environment" {
  description = "The environment that the AWS resources are instantiated in"
  type        = string
  nullable    = false
}

variable "log_retention_in_days" {
  description = "The number of days to store logs for the Coordinator API CloudWatch logs."
  type        = number
}

variable "handle_onboarding_request_lambda_file_path" {
  description = "File path for handle onboarding request lambda"
  type        = string
  nullable    = false
}

variable "handle_offboarding_request_lambda_file_path" {
  description = "File path for handle offboarding request lambda"
  type        = string
  nullable    = false
}

variable "handle_read_adtech_request_lambda_file_path" {
  description = "File path for handle read request lambda"
  type        = string
  nullable    = false
}

variable "pbs_auth_db_arn" {
  description = "ARN of PBS Auth database"
  type        = string
  nullable    = false
}

variable "pbs_auth_db_name" {
  description = "Name of PBS Auth database"
  type        = string
  nullable    = false
}

variable "iam_policy_arn" {
  description = "ARN of the policy to be attached to the adtech's IAM role"
  type        = string
  nullable    = false
}
