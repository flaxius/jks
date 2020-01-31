#!/bin/bash


installStartDocker() {
  if [ -x "$(command -v docker)" ]; then
    echo "[INFO] Docker already installed"
  else
    echo "[INFO] Installing docker..."
    yum install --assumeyes -d1 yum-utils device-mapper-persistent-data lvm2
    yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum install --assumeyes -d1 docker-ce
    systemctl start docker
    docker version
  fi
}

install_required_packages() {
    sudo apt -y install qemu-kvm libvirt-daemon libvirt-daemon-system
    sudo apt -y install libvirt-bin qemu-kvm
    sudo usermod -a -G libvirt $(whoami)
    sudo curl -L https://github.com/dhiltgen/docker-machine-kvm/releases/download/v0.10.0/docker-machine-driver-kvm-ubuntu16.04 -o /usr/local/bin/docker-machine-driver-kvm
    sudo chmod +x /usr/local/bin/docker-machine-driver-kvm
    sudo systemctl start libvirtd
    echo '[INFO]CICO: Required virtualization packages installed'
}

setup_kvm_machine_driver() {
    echo "[INFO] Installing docker machine kvm drivers..."
    sudo curl -L https://github.com/dhiltgen/docker-machine-kvm/releases/download/v0.10.0/docker-machine-driver-kvm-centos7 -o /usr/bin/docker-machine-driver-kvm
    sudo chmod +x /usr/bin/docker-machine-driver-kvm
}

minishift_installation() {
  MSFT_RELEASE="1.34.2"
  echo "[INFO] Downloading Minishift binaries..."
  sudo curl -s -S -L https://github.com/minishift/minishift/releases/download/v$MSFT_RELEASE/minishift-$MSFT_RELEASE-linux-amd64.tgz \
    -o ${OPERATOR_REPO}/tmp/minishift-$MSFT_RELEASE-linux-amd64.tar && sudo tar -xvf ${OPERATOR_REPO}/tmp/minishift-$MSFT_RELEASE-linux-amd64.tar -C /usr/local/bin --strip-components=1
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