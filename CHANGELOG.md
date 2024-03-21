# Changelog

## [1.6.1](https://github.com/privacysandbox/coordinator-services-and-shared-libraries/compare/v1.6.0...v1.6.1) (2024-03-19)

* **Important note**
  * **[AWS only]** Cloudwatch alerting changes requires special handling in order to preserve log:
    * Prior to generating the Terraform plan, run the following command:
      `terraform import module.distributedpbs_application.module.auth_service.aws_cloudwatch_log_group.lambda_cloudwatch /aws/lambda/${environment}-google-scp-pbs-auth-lambda`
    * In case of rollback, prior to generate the Terraform plan, run the following:
      `terraform state rm module.distributedpbs_application.module.auth_service.aws_cloudwatch_log_group.lambda_cloudwatch`
  * **[GCP only]** GCP coordinator services is officially open sourced with this release.

### Changes
  * Added api_gateway and lambda alarms for PBS Auth service
  * Fixed a bug where PBS is not picking up the correct parameters for refreshing leader lease; it wwill refresh the lease more frequently (every 5s) after this fix
  * Pinned Docker engine version to 24.0.5 for operator AMI build
  * Switched PBS instance disk to regional SSD
  * Updated container dependencies
  * Updated logging in PBS so that only the first 5 journal IDs are logged
  * Updated PBS instance startup script to increase the soft file descriptor limit
  * [GCP only] Updated fluentd config for PBS so that PBS logs are parsed correctly before being sent to GCP Cloud Logging

## [1.6.0](https://github.com/privacysandbox/coordinator-services-and-shared-libraries/compare/v1.5.1...v1.6.0) (2024-02-29)

* **Important note**
  * SSH access to PBS EC2 instances restricted to localhost only
  * Starting with this patch, terraform variables allowed_principals_map and allowed_principals are no longer supported and need to be removed from the tfvars file in roleprovider environment.
  * **[AWS only]** Possible Action Required in primary coordinator: \
  This release includes terraform change for adding dynamodb:DeleteItem permission in the multiparty key generation service.
  It possibly requires more permission in terraform deployment role.

### Changes
  * Added dynamodb:DeleteItem permission to key generation service instance
  * Added exception handlers in GcsBlobStorageClient
  * Added logic to clean up temp key and retry when key generation fails
  * Added probers for coordinator services
  * Added validation around 'job_request_id' parameter of the GetJob API
  * Changed attribute mapping in WIPP to remove token creation limitation
  * Created an autoscaling hook so worker instances can be updated without interrupting current running jobs
  * Disallowed unencrypted S3 data transports
  * Enabled flexibility in tuning individual MPKHS and PBS alarms independently
  * [Java CPIO library] Increased private key cache TTL to 8 hours for Java client
  * Made MPKHS prober alarm service label more descriptive
  * Migrated operator IAM roles to be created using allowed_principals_map_v2 and removed the now deprecated allowed_principals_map
  * Removed single coordinator PBS code and associated tests
  * Set prod confidential space image as the default
  * Updated container dependencies
  * Updated PBS client to support the PBS APIv2 schema
  * Upgraded PBS Client library to support PBS API changes for supporting budget consumption of budget keys belonging to multiple reporting origins

## [1.5.1](https://github.com/privacysandbox/coordinator-services-and-shared-libraries/compare/v1.5.0...v1.5.1) (2023-12-12)

* **Important note**
  * SSH access to PBS EC2 instances now restricted to localhost only
  * Starting with this patch, terraform variables allowed_principals_map and allowed_principals are no longer supported and need to be removed from the tfvars file in roleprovider environment

### Changes
  * Limited SSH access to PBS EC2 instances from localhost only
  * Changed to generate operator IAM roles based on new allowed_principals_map_v2 map
  * Added necessary tools (python3-venv & zip) to install during the build container Docker build process
  * Updated container dependencies
  * Fixed GCP alarm window functions

## [1.5.0](https://github.com/privacysandbox/coordinator-services-and-shared-libraries/compare/v1.4.0...v1.5.0) (2023-11-14)

* **Important note**
  * To set the stage for enabling per-site enrollment on AWS:
    * In the `auto.tfvars` file of distributedpbs_application, in the `application_environment_variables` map, add the following line
      ```
      google_scp_pbs_authorization_enable_site_based_authorization = "false"
      ```
  * Rollback steps:
      * Rollback the terraform changes performed in the above steps.
      * Deploy the older code (v1.4.0) along with the rolled back terraform changes.

### Changes
  * Added per-site enrollment feature behind a feature flag
  * Allowlisted remote coordinator's site information in the new auth table as part of deployment
  * Removed UnifiedKeyHostingApiGatewayTotalErrorRatioHigh alarm
  * Enabled userArn context in api gateway logging
  * Enabled point in time recovery for the partition lock table
  * Updated AWS authorizer lambda to always force https protocol on reporting origin from requests
  * Updated default alerting window to 5 minutes for KHS alarms

## [1.4.0](https://github.com/privacysandbox/coordinator-services-and-shared-libraries/compare/v1.3.0...v1.4.0) (2023-10-11)

* **Important note**
  * To enable batching of metrics, the following line needs to be added to the auto.tfvars of the distributedpbs_application in the application_environment_variables variable map.
    ```
    application_environment_variables = {
      google_scp_pbs_metrics_batch_push_enabled = "true"
    }
    ```
  * To be compatible to the existing Aggregation service versions, the following line needs to be added to the auto.tfvars of mpkhs_primary and mpkhs_secondary
    ```
    get_encryption_key_lambda_ps_client_shim_enabled = true
    ```

### Changes
  * Added support for Google Cloud Platform (GCP)
  * Added new API endpoint to serve public keys in the Key Hosting Service
  * Added use of S3TransferManager to support multi-threaded uploads for BlobStorageClient
  * Added sending notifications when alarms transition to ok state
  * Disabled GCP CDN logs to avoid logging sensitive information
  * Updated Guava library version to v32.0.1
  * Updated Jackson library version to v2.15.2
  * Updated Java base to the latest version as of 09/18/2023
  * Updated Amazon Linux 2 to v2.0.20230912
  * Addressed bug in PBS checkpoint service thread
  * Addressed race condition between Stop and Transactions entering the Transaction Manager
  * Addressed Journal Recovery bug during Checkpointing
  * Addressed VNode Lease Count fluctuation
  * Addressed NgHttp2 callback related crashes in Http2Server
  * Addressed losing kLeaseAcquired event when re-acquring Lease immediately
  * Addressed issue in BudgetKeyProvider's Stop()

## [1.3.0](https://github.com/privacysandbox/coordinator-services-and-shared-libraries/compare/v1.2.0...v1.3.0) (2023-09-27)

### Changes
  * Set finishedAt field when appending job metadata error message
  * Disabled warnings about unencrypted SNS topics
  * Renamed all alerts to follow the new naming format
  * Added API version to MPKHS public key serving path
  * Added new path for MPKHS to serve public keys
  * Added the ability to support multiple domains for the public key endpoint
  * Added ProcessingStartTime in Job Object
  * Added OTel metrics control in terraform
  * Updated PBS elasticbeanstalk configuration to ignore 4xx app and lb errors during health reporting

## [1.2.0](https://github.com/privacysandbox/coordinator-services-and-shared-libraries/compare/v1.1.1...v1.2.0) (2023-08-24)

### Changes
  * Fixed terraform plan output
  * Extended operator lifecycle hook timeout
  * Added Codebuild terraform and instructions

## [1.1.1](https://github.com/privacysandbox/coordinator-services-and-shared-libraries/compare/v1.1.0...v1.1.1) (2023-08-08)

### Changes
  * Ensured ACL is set on CloudFront logs bucket by adding an explicit dependency
  * Added option to uninstall SSH server from AMI
  * Pinned and locked versions for nsm-api dependencies
  * Enforced newer SSLPolicy on ELB LB

## [1.1.0](https://github.com/privacysandbox/coordinator-services-and-shared-libraries/compare/v1.0.0...v1.1.0) (2023-07-27)

### Changes
- Fixed Alert-Queue by updating region
- Fixed kmstool build by upgrading rust toolchain to 1.63 and pinning the nsm-api dependencies
- Added retry with exponential back off for decryption service
- Added new error code to map private key endpoint
- Improved ConstantJobClient usability for testing

## [1.0.0](https://github.com/privacysandbox/coordinator-services-and-shared-libraries/compare/v0.51.15...v1.0.0) (2023-07-10)

### Changes

- Release of first major version v1.0.0 including open sourcing of coordinator services source code
