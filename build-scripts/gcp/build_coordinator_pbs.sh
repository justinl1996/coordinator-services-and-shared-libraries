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

GCP_PROJECT_ID=$1
ARTIFACT_REGISTRY_NAME=$2
TAG=$3

cp cc/tools/build/build_container_params.bzl.prebuilt cc/tools/build/build_container_params.bzl

CONTAINER_REGISTRY="us-central1-docker.pkg.dev"
default_pbs_image_repo="bazel/cc/pbs/deploy/pbs_server/build_defs"

bazel build //coordinator/terraform/gcp:multiparty_dist_files
pbs_container_image_tar_path="cc/pbs/deploy/pbs_server/build_defs/reproducible_pbs_container_gcp.tar"

# Load the PBS container image
docker load < "$(bazel info bazel-bin)/$pbs_container_image_tar_path"

gcloud --quiet auth configure-docker $CONTAINER_REGISTRY

# Create new image tag name
new_image_tag="$CONTAINER_REGISTRY/$GCP_PROJECT_ID/$ARTIFACT_REGISTRY_NAME/pbs-image:$TAG"

# Tag image to push to the registry
docker images
docker tag $default_pbs_image_repo:pbs_container_gcp $new_image_tag
docker push $new_image_tag