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

IMAGE_REPO_PATH=$1
IMAGE_NAME=$2
IMAGE_TAG=$3

KEY_GENERATION_LOG=$(pwd)/buildlog.txt
cp cc/tools/build/build_container_params.bzl.prebuilt cc/tools/build/build_container_params.bzl

bazel run //coordinator/keygeneration/gcp:key_generation_app_mp_gcp_image_prod \
--sandbox_writable_path=$HOME/.docker \
-- -dst "${IMAGE_REPO_PATH}/${IMAGE_NAME}:${IMAGE_TAG}" \
| tee "${KEY_GENERATION_LOG}"