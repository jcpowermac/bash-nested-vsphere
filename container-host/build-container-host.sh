#!/bin/bash

export GOVC_URL=vcenter
export GOVC_USERNAME="administrator@vsphere.local"
export GOVC_PASSWORD=""
export GOVC_INSECURE=1
export GOVC_DATACENTER=dc1
export GOVC_DATASTORE=datastore1
export GOVC_CLUSTER=cluster1
export GOVC_RESOURCE_POOL=/dc1/host/cluster1/Resources

VM_NAME=fcos-create-vcsa

VCSA_ISO=iso/vcsa.iso

FCOS_OVA_URL="https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/33.20210117.3.2/x86_64/fedora-coreos-33.20210117.3.2-vmware.x86_64.ova"
GOVC_URL="https://github.com/vmware/govmomi/releases/download/v0.24.0/govc_linux_amd64.gz"
FCCT_URL="https://github.com/coreos/fcct/releases/download/v0.10.0/fcct-x86_64-unknown-linux-gnu"

if [ ! -f govc  ]; then
    echo "Downloading govc..."
    curl -L ${GOVC_URL} | gunzip > govc
    chmod +x govc
fi

if [ ! -f fedora-coreos.ova ]; then
    echo "Downloading Fedora CoreOS OVA..."
    wget --show-progress -nc -O fedora-coreos.ova "${FCOS_OVA_URL}"
fi
if [ ! -f fcct ]; then
    echo "Downloading fcct..."
    wget --show-progress -nc -O fcct "${FCCT_URL}"
    chmod +x fcct
fi

govc import.ova -name "${VM_NAME}" fedora-coreos.ova

CONFIG_DATA=$(./fcct -strict < fcos.yaml | base64 -w0 -)

govc vm.change -vm "${VM_NAME}" \
    -e guestinfo.ignition.config.data=${CONFIG_DATA} \
    -e guestinfo.ignition.config.data.encoding="base64"

govc device.cdrom.insert -vm "${VM_NAME}" "${VCSA_ISO}"
