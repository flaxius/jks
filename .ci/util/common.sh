#
# Copyright (c) 2012-2020 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
# Contributors:
#   Red Hat, Inc. - initial API and implementation

set -e -x

installStartDocker() {
  if [ -x "$(command -v docker)" ]; then
    echo "[INFO] Docker already installed"
  else
    echo "[INFO] Installing docker..."
    sudo yum install --assumeyes -d1 yum-utils device-mapper-persistent-data lvm2
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo yum install --assumeyes -d1 docker-ce
    sudo systemctl start docker
    sudo docker version
  fi
}

install_required_packages() {
    # Install EPEL repo
    # Get all the deps in
    sudo yum -y install libvirt qemu-kvm
  echo '[INFO]CICO: Required virtualization packages installed'
}

start_libvirt() {
  sudo systemctl start libvirtd
}

setup_kvm_machine_driver() {
    echo "[INFO] Installing docker machine kvm drivers..."
    sudo curl -L https://github.com/dhiltgen/docker-machine-kvm/releases/download/v0.10.0/docker-machine-driver-kvm-centos7 -o /usr/local/bin/docker-machine-driver-kvm
    sudo chmod +x /usr/local/bin/docker-machine-driver-kvm
    sudo systemctl start libvirtd
}who

minishift_installation() {
  MSFT_RELEASE="1.34.2"
  echo "[INFO] Downloading Minishift binaries..."
  curl -s -S -L https://github.com/minishift/minishift/releases/download/v$MSFT_RELEASE/minishift-$MSFT_RELEASE-linux-amd64.tgz \
    -o ${OPERATOR_REPO}/tmp/minishift-$MSFT_RELEASE-linux-amd64.tar && sudo tar -xvf ${OPERATOR_REPO}/tmp/minishift-$MSFT_RELEASE-linux-amd64.tar -C /usr/bin --strip-components=1
  echo "[INFO] Sarting a new OC cluster."
  minishift start --memory=4096 && eval $(minishift oc-env)
  oc login -u system:admin
  oc adm policy add-cluster-role-to-user cluster-admin developer && oc login -u developer -p developer
}

generate_self_signed_certs() {
    IP_ADDRESS="172.17.0.1"
    openssl req -x509 \
                -newkey rsa:4096 \
                -keyout key.pem \
                -out cert.pem \
                -days 365 \
                -subj "/CN=*.${IP_ADDRESS}.nip.io" \
                -nodes && cat cert.pem key.pem > ca.crt    
}