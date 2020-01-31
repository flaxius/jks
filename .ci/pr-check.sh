#!/bin/bash
BASE_DIR=$(cd "$(dirname "$0")"; pwd)
set -x
  if [ ! -d "$OPERATOR_REPO/tmp" ]; then mkdir -p "$OPERATOR_REPO/tmp" && chmod 777 "$OPERATOR_REPO/tmp"; fi

source ${BASE_DIR}/util/common.sh
installStartDocker
install_required_packages
setup_kvm_machine_driver
minishift_installation