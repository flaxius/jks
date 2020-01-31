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
     cat /etc/os-release
     apk add --update nodejs npm
     node -v
    apt install qemu-kvm libvirt-daemon libvirt-daemon-system
    apt install libvirt-bin qemu-kvm
    usermod -a -G libvirt $(whoami)
    curl -L https://github.com/dhiltgen/docker-machine-kvm/releases/download/v0.10.0/docker-machine-driver-kvm-ubuntu16.04 -o /usr/local/bin/docker-machine-driver-kvm
    chmod +x /usr/local/bin/docker-machine-driver-kvm
    systemctl start libvirtd
    echo '[INFO]CICO: Required virtualization packages installed'
}