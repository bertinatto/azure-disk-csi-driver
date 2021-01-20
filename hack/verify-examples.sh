#!/bin/bash
# Copyright 2020 The Kubernetes Authors.
#
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

set -euo pipefail

echo "begin to create deployment examples ..."

kubectl apply -f deploy/example/storageclass-azuredisk-csi.yaml

if [[ "$1" == "linux" ]]; then
    kubectl apply -f deploy/example/deployment.yaml
    kubectl apply -f deploy/example/statefulset.yaml
    kubectl apply -f deploy/example/statefulset-nonroot.yaml
fi

if [[ "$1" == "windows" ]]; then
    kubectl apply -f deploy/example/windows/deployment.yaml
    kubectl apply -f deploy/example/windows/statefulset.yaml
fi

echo "sleep 180s ..."
sleep 180

echo "begin to check pod status ..."
kubectl get pods

if [[ "$1" == "linux" ]]; then
    kubectl get pods --field-selector status.phase=Running | grep deployment-azuredisk
    kubectl get pods --field-selector status.phase=Running | grep statefulset-azuredisk-0
    kubectl get pods --field-selector status.phase=Running | grep statefulset-azuredisk-nonroot-0
fi

if [[ "$1" == "windows" ]]; then
    echo "sleep 120s for Windows ..."
    sleep 120
    kubectl get pods --field-selector status.phase=Running | grep deployment-azuredisk-win
    kubectl get pods --field-selector status.phase=Running | grep statefulset-azuredisk-win-0
fi

echo "deployment examples running completed."