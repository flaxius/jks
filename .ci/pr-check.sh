#!/bin/bash
BASE_DIR=$(cd "$(dirname "$0")"; pwd)
set -x

source ${BASE_DIR}/util/common.sh
  if [ ! -d "$OPERATOR_REPO/tmp" ]; then mkdir -p "$OPERATOR_REPO/tmp" && chmod 777 "$OPERATOR_REPO/tmp"; fi
installStartDocker
install_required_packages
setup_kvm_machine_driver
minishift_installation