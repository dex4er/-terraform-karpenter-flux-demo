#!/bin/bash

set -euo pipefail
shopt -s inherit_errexit 2>/dev/null || true

while true; do
  kubectl get node -L node.kubernetes.io/instance-type,eks.amazonaws.com/nodegroup,karpenter.sh/provisioner-name |
    while read -r name _status roles _age _version type nodegroup provisioner; do
      if [[ ${roles} == "<none>" ]]; then
        if [[ -n ${nodegroup} ]]; then
          kubectl label node ${name} node-role.kubernetes.io/${nodegroup}.${type}=
        elif [[ -n ${provisioner} ]]; then
          kubectl label node ${name} node-role.kubernetes.io/${provisioner}.${type}=
        fi
      fi
    done
  sleep 10
done
