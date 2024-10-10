#!/bin/bash
# Copyright 2024 Google LLC
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

set -eux
set -o pipefail

AWS_DEFAULT_REGION="us-east-1"
KEY_GENERATION_LOG=$(pwd)/buildlog.txt
COORDINATOR_VERSION=$(cat version.txt)
KEY_GENERATION_AMI="aggregation-service-keygeneration-enclave-prod-${COORDINATOR_VERSION}"

cp cc/tools/build/build_container_params.bzl.prebuilt cc/tools/build/build_container_params.bzl

pwd
whoami
hostname

bazel run //coordinator/keygeneration/aws:prod_keygen_ami \
	--spawn_strategy=local \
	--sandbox_writable_path=$HOME/.docker \
	--//coordinator/keygeneration/aws:keygeneration_ami_name="${KEY_GENERATION_AMI}" \
	--//coordinator/keygeneration/aws:keygeneration_ami_region="${AWS_DEFAULT_REGION}" | tee "${KEY_GENERATION_LOG}"
	