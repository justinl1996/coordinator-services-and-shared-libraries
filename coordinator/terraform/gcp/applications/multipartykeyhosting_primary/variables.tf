# Copyright 2022 Google LLC
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

################################################################################
# Global Variables.
################################################################################

variable "project_id" {
  description = "GCP Project ID in which this module will be created."
  type        = string
}

variable "environment" {
  description = "Description for the environment, e.g. dev, staging, production."
  type        = string
}

variable "allowed_operator_user_group" {
  description = "Google group of allowed operators to which to give API access."
  type        = string
}

variable "primary_region" {
  description = "Region where all services will be created."
  type        = string
}

variable "primary_region_zone" {
  description = "Region zone where all services will be created."
  type        = string
}

variable "secondary_region" {
  description = "Region where all services will be replicated."
  type        = string
}

variable "key_generation_allow_stopping_for_update" {
  description = "If true, allows Terraform to stop the key generation instances to update their properties. If you try to update a property that requires stopping the instances without setting this field, the update will fail."
  type        = bool
  default     = false
}

variable "mpkhs_primary_package_bucket_location" {
  description = "Location for multiparty keyhosting packages. Example: 'US'."
  type        = string
}

################################################################################
# Global Alarm Variables.
################################################################################

variable "alarms_enabled" {
  description = "Enable alarms for mpkhs services."
  type        = bool
}

variable "alarms_notification_email" {
  description = "Email to receive alarms for mpkhs services."
  type        = string
}

################################################################################
# Spanner Variables.
################################################################################

variable "spanner_instance_config" {
  description = "Config value for the Spanner Instance. Example: 'nam10'."
  type        = string
}

variable "spanner_processing_units" {
  description = "Spanner's compute capacity. 1000 processing units = 1 node and must be set as a multiple of 100."
  type        = number
}

# Similar to Point-in-time recovery for AWS DynamoDB
# Must be between 1 hour and 7 days. Can be specified in days, hours, minutes, or seconds.
# eg: 1d, 24h, 1440m, and 86400s are equivalent.
variable "key_db_retention_period" {
  description = "Duration to maintain table versioning for point-in-time recovery."
  type        = string
  nullable    = false
}

################################################################################
# Key Generation Variables.
################################################################################

variable "key_generation_image" {
  description = "The Key Generation Application docker image."
  type        = string
}

variable "key_generation_count" {
  description = "Number of keys to generate at a time."
  type        = number

  validation {
    condition     = var.key_generation_count > 0
    error_message = "Must be greater than 0."
  }
}

variable "key_generation_validity_in_days" {
  description = "Number of days keys will be valid. Should be greater than generation days for failover validity."
  type        = number

  validation {
    condition     = var.key_generation_validity_in_days > 0
    error_message = "Must be greater than 0."
  }
}

variable "key_generation_ttl_in_days" {
  description = "Keys will be deleted from the database this number of days after creation time."
  type        = number
  validation {
    condition     = var.key_generation_ttl_in_days > 0
    error_message = "Must be greater than 0."
  }
}

variable "key_generation_cron_schedule" {
  description = <<-EOT
    Frequency for key generation cron job. Must be valid cron statement. Default is every Monday at 10AM
    See documentation for more details: https://cloud.google.com/scheduler/docs/configuring/cron-job-schedules
  EOT
  type        = string
}

variable "key_generation_cron_time_zone" {
  description = "Time zone to be used with cron schedule."
  type        = string
}

variable "instance_disk_image" {
  description = "The image from which to initialize the key generation instance disk for TEE."
  type        = string
}

variable "key_generation_logging_enabled" {
  description = "Whether to enable logging for Key Generation instance."
  type        = bool
}

variable "key_generation_monitoring_enabled" {
  description = "Whether to enable monitoring for Key Generation instance."
  type        = bool
}

variable "key_generation_tee_restart_policy" {
  description = "The TEE restart policy. Currently only supports Never."
  type        = string
}

variable "key_generation_tee_allowed_sa" {
  description = "The service account provided by Coordinator B for key generation instance to impersonate."
  type        = string
}

variable "key_generation_undelivered_messages_threshold" {
  description = "Total Queue Messages greater than this to send alert."
  type        = number
}

variable "key_generation_alignment_period" {
  description = "Alignment period of key generation alert metrics in seconds. This value should match the period of the cron schedule."
  type        = number

  validation {
    # This value should match the period of the cron schedule.
    # Used for the alignment period of alert metrics.
    # Max 81,000 seconds due to the max GCP metric-threshold evaluation period
    # (23 hours, 30 minutes) plus an extra hour to allow fluctuations in
    # execution time.
    condition     = var.key_generation_alignment_period > 0 && var.key_generation_alignment_period < 81000
    error_message = "Must be between 0 and 81,000 seconds."
  }
}

variable "key_gen_instance_force_replace" {
  description = "Whether to force key generation instance replacement for every deployment."
  type        = bool
}

variable "peer_coordinator_kms_key_uri" {
  description = "KMS key URI for peer coordinator."
  type        = string
}

variable "key_storage_service_base_url" {
  description = "Base url for key storage service for peer coordinator."
  type        = string
}

// TODO(b/275758643)
variable "key_storage_service_cloudfunction_url" {
  description = "Cloud function url for peer coordinator."
  type        = string
}

variable "peer_coordinator_wip_provider" {
  description = "Peer coordinator wip provider address."
  type        = string
}

variable "peer_coordinator_service_account" {
  description = "Service account generated from peer coordinator."
  type        = string
}

variable "key_id_type" {
  description = "Key ID Type"
  type        = string
}

################################################################################
# Routing Variables.
################################################################################

variable "enable_domain_management" {
  description = "Manage domain SSL cert creation and routing for public and encryption key services."
  type        = bool
}

variable "parent_domain_name" {
  description = "Custom domain name to use with key hosting APIs."
  type        = string
}

variable "parent_domain_name_project" {
  description = "Project ID where custom domain name hosted zone is located."
  type        = string
}

variable "service_subdomain_suffix" {
  description = "When set, the value replaces `-$${var.environment}` as the service subdomain suffix."
  type        = string
}

variable "public_key_service_subdomain" {
  description = "Subdomain to use with parent_domain_name to designate the public key service."
  type        = string
}

variable "public_key_service_alternate_domain_names" {
  description = "A list of alternate domain names for the public key service for which to add as a subject alternative name in the SSL certificate. Eg: [service-example.com]"
  type        = list(string)
}

variable "encryption_key_service_subdomain" {
  description = "Subdomain to use with parent_domain_name to designate the encryption key service."
  type        = string
}

################################################################################
# Cloud Function Variables.
################################################################################

variable "cloudfunction_timeout_seconds" {
  description = "Number of seconds after which a function instance times out."
  type        = number
}

variable "get_public_key_service_zip" {
  description = <<-EOT
          Get Public key service cloud function path. If not provided defaults to locally built zip file.
        Build with `bazel build //coordinator/terraform/gcp/applications/multipartykeyhosting_primary:all`.
      EOT
  type        = string
}

variable "encryption_key_service_zip" {
  description = <<-EOT
          Encryption key service cloud function path. If not provided defaults to locally built zip file.
        Build with `bazel build //coordinator/terraform/gcp/applications/multipartykeyhosting_primary:all`.
      EOT
  type        = string
}

variable "get_public_key_cloudfunction_memory_mb" {
  description = "Memory size in MB for public key cloud function."
  type        = number
}

variable "encryption_key_service_cloudfunction_memory_mb" {
  description = "Memory size in MB for encryption key cloud function."
  type        = number
}

variable "get_public_key_cloudfunction_min_instances" {
  description = "The minimum number of function instances that may coexist at a given time."
  type        = number
}

variable "encryption_key_service_cloudfunction_min_instances" {
  description = "The minimum number of function instances that may coexist at a given time."
  type        = number
}

variable "get_public_key_cloudfunction_max_instances" {
  description = "The maximum number of function instances that may coexist at a given time."
  type        = number
}

variable "encryption_key_service_cloudfunction_max_instances" {
  description = "The maximum number of function instances that may coexist at a given time."
  type        = number
}

variable "application_name" {
  description = "Application name to separate serving path for public key service endpoint. Eg: aggregation-service."
  type        = string
}

################################################################################
# Key Management Variables.
################################################################################

variable "enable_get_public_key_cdn" {
  description = "Enable Get Public Key API CDN."
  type        = bool
}

variable "get_public_key_cloud_cdn_default_ttl_seconds" {
  description = "Default CDN TTL seconds to use when no cache headers are present."
  type        = number
}

variable "get_public_key_cloud_cdn_max_ttl_seconds" {
  description = "Maximum CDN TTL seconds that cache header directive cannot surpass."
  type        = number
}

################################################################################
# Public Key Alarm Variables.
################################################################################

variable "get_public_key_alarm_eval_period_sec" {
  description = "Amount of time (in seconds) for alarm evaluation. Example: '60'."
  type        = string
}

variable "get_public_key_alarm_duration_sec" {
  description = "Amount of time (in seconds) after which to send alarm if conditions are met. Must be in minute intervals. Example: '60','120'."
  type        = string
}

variable "get_public_key_cloudfunction_error_threshold" {
  description = "Error count greater than this to send alarm. Example: 0."
  type        = string
}

variable "get_public_key_cloudfunction_max_execution_time_max" {
  description = "Max execution time in ms to send alarm. Example: 9999."
  type        = string
}

variable "get_public_key_cloudfunction_5xx_threshold" {
  description = "Cloud Function 5xx error count greater than this to send alarm. Example: 0."
  type        = string
}

variable "get_public_key_lb_max_latency_ms" {
  description = "Load Balancer max latency to send alarm. Measured in milliseconds. Example: 5000."
  type        = string
}

variable "get_public_key_lb_5xx_threshold" {
  description = "Load Balancer 5xx error count greater than this to send alarm. Example: 0."
  type        = string
}

################################################################################
# Encryption Key Service Alarm Variables.
################################################################################

variable "encryptionkeyservice_alarm_eval_period_sec" {
  description = "Amount of time (in seconds) for alarm evaluation. Example: '60'."
  type        = string
}

variable "encryptionkeyservice_cloudfunction_error_threshold" {
  description = "Error count greater than this to send alarm. Example: 0."
  type        = string
}

variable "encryptionkeyservice_cloudfunction_max_execution_time_max" {
  description = "Max execution time in ms to send alarm. Example: 9999."
  type        = string
}

variable "encryptionkeyservice_cloudfunction_5xx_threshold" {
  description = "Cloud Function 5xx error count greater than this to send alarm. Example: 0."
  type        = string
}

variable "encryptionkeyservice_lb_max_latency_ms" {
  description = "Load Balancer max latency to send alarm. Measured in milliseconds. Example: 5000."
  type        = string
}

variable "encryptionkeyservice_lb_5xx_threshold" {
  description = "Load Balancer 5xx error count greater than this to send alarm. Example: 0."
  type        = string
}

variable "encryptionkeyservice_alarm_duration_sec" {
  description = "Amount of time (in seconds) after which to send alarm if conditions are met. Must be in minute intervals. Example: '60','120'."
  type        = number
}
