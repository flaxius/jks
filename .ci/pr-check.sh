#!/bin/bash
BASE_DIR=$(cd "$(dirname "$0")"; pwd)

source ${BASE_DIR}/util/common.sh
installStartDocker
install_required_packages