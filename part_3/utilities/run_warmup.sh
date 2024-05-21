#!/bin/bash

# Copyright (c) 2023 NVIDIA CORPORATION. All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License. 

MODEL_NAME=${1:-"bert"}
BATCH_SIZE=${2:-1}
MEASUREMENT_REQUEST_COUNT=${3:-25}
MODEL_VERSION=${4:-1}
precision=${5:-"fp32"}
MAX_LATENCY=${6:-500}
MAX_CLIENT_THREADS=${7:-10}
MAX_CONCURRENCY=${8:-50}
SERVER_HOSTNAME=${9:-"triton"}
DOCKER_BRIDGE=${10:-"host"}
RESULTS_ID=${11:-""}
PROFILING_DATA=${12:-"utilities/profiling_data_int64"}
PERCENTILE_STABILITY_COMPARISON=${13:-50}
STABILITY_PERCENTAGE=${14:-10}
NV_VISIBLE_DEVICES=${15:-"0"}

if [[ $SERVER_HOSTNAME == *":"* ]]; then
  echo "ERROR! Do not include the port when passing the Server Hostname. These scripts require that the TRITON HTTP endpoint is on Port 8000 and the gRPC endpoint is on Port 8001. Exiting..."
  exit 1
fi

# add wait because server is polling model repository
sleep 10

# Wait until server is up. curl on the health of the server and sleep until its ready
bash utilities/wait_for_triton_server.sh $SERVER_HOSTNAME

TIMESTAMP=$(date "+%y%m%d_%H%M")

# Create model directory on host (directory /results is mounted)
mkdir -p ./results/${MODEL_NAME}

if [ ! -z "${RESULTS_ID}" ];
then
    RESULTS_ID="_${RESULTS_ID}"
fi

OUTPUT_FILE_CSV="./results/${MODEL_NAME}/results${RESULTS_ID}_${TIMESTAMP}.csv"

ARGS="\
   -m ${MODEL_NAME} \
   -x ${MODEL_VERSION} \
   -i gRPC \
   -u ${SERVER_HOSTNAME}:8001 \
   -b ${BATCH_SIZE} \
   -l ${MAX_LATENCY} \
   --concurrency-range 1 \
   -f ${OUTPUT_FILE_CSV} \
   --measurement-mode count_windows \
   --input-data ${PROFILING_DATA} \
   --percentile 85 \
   --stability-percentage 500 \
   --measurement-request-count ${MEASUREMENT_REQUEST_COUNT}"

# /usr/local/bin/perf_analyzer $ARGS
/opt/triton_clients/bin/perf_analyzer $ARGS
