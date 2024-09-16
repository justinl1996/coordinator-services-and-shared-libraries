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

TAR_BUCKET=$1
TAR_PATH=$2
COMPONENT=$3

KEY_GENERATION_LOG=$(pwd)/buildlog.txt
cp cc/tools/build/build_container_params.bzl.prebuilt cc/tools/build/build_container_params.bzl

deploy_encryption_key_jar () {
    bazel build //coordinator/terraform/aws:encryption_key_service_jar
    ZIP_FILE="$(bazel info bazel-bin)/java/com/google/scp/coordinator/keymanagement/keyhosting/service/aws/EncryptionKeyServiceLambda_deploy.jar"
    MD5=$(md5sum $ZIP_FILE | cut -d' ' -f1)
    aws s3 cp ${ZIP_FILE} s3://${TAR_BUCKET}/${TAR_PATH}/${MD5}
}

deploy_public_key_jar () {
    bazel build //coordinator/terraform/aws:public_key_service_jar
    ZIP_FILE="$(bazel info bazel-bin)/java/com/google/scp/coordinator/keymanagement/keyhosting/service/aws/PublicKeyApiGatewayHandlerLambda_deploy.jar"
    MD5=$(md5sum $ZIP_FILE | cut -d' ' -f1)
    aws s3 cp ${ZIP_FILE} s3://${TAR_BUCKET}/${TAR_PATH}/${MD5}
}

deploy_key_storage_jar () {
    bazel build //coordinator/terraform/aws:key_storage_service_jar
    ZIP_FILE="$(bazel info bazel-bin)/java/com/google/scp/coordinator/keymanagement/keystorage/service/aws/KeyStorageServiceLambda_deploy.jar"
    MD5=$(md5sum $ZIP_FILE | cut -d' ' -f1)
    aws s3 cp ${ZIP_FILE} s3://${TAR_BUCKET}/${TAR_PATH}/${MD5}
}

case $COMPONENT in

  encryption_key)
    deploy_encryption_key_jar
    ;;

  public_key)
    deploy_public_key_jar
    ;;

  key_storage)
    deploy_key_storage_jar
    ;;

  *)
    echo "Unknown Component"
    ;;
esac