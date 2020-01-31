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
    # Install EPEL repo
    # Get all the deps in
    yum -y install libvirt qemu-kvm
  echo '[INFO]CICO: Required virtualization packages installed'
}