# Changelog

## [1.4.0](https://github.com/privacysandbox/coordinator-services-and-shared-libraries/compare/v1.3.0-RC...v1.4.0-rc02) (2023-10-20)

 * **Important note**

   To enable batching of metrics, the following line needs to be added to the auto.tfvars of the distributedpbs_application in the application_environment_variables variable map.
    ```
    application_environment_variables = {
      google_scp_pbs_metrics_batch_push_enabled = "true"
    }
    ```
   To be compatible to the existing Aggregation service versions, the following line needs to be added to the auto.tfvars of mpkhs_primary and mpkhs_secondary
    ```
    get_encryption_key_lambda_ps_client_shim_enabled = true
    ```

  * Fixed sharded summary report multi-threaded upload by using S3 TransferManager for aws
  * Changed key-split encryption with public key as associated data
  * Fixed missing permission for key storage to re-encrypt key-split
  * Added caller identity for jobs
  * Extended lifecycle hook timeout

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
