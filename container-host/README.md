## Fedora CoreOS container host

The script `./build-container-host.sh` downloads `govc`, Fedora CoreOS OVA and fcct.
It then imports the OVA into vSphere and sets an extra config to configure Fedora CoreOS.

### Setup

You will need to configure the following within the script:
```
export GOVC_URL=vcenter
export GOVC_USERNAME=""
export GOVC_PASSWORD=""
export GOVC_INSECURE=1
export GOVC_DATACENTER=dc1
export GOVC_DATASTORE=datastore1
export GOVC_CLUSTER=cluster1
```
The default password for the user `core` is set to `redhat!123`

### Containers

To use the `vmware-vspc-powercli` log into the machine
and execute:

```
sudo podman exec -it vmware-vspc-powercli pwsh
```
