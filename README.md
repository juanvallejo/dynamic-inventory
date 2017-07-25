Dynamic Inventory Generation
============================

Docker image for creating a container capable of
connecting to an OpenShift master and dynamically
creating an inventory file from its environment.

### Build

`docker build --rm -t juanvallejo/inventory-gen .`

### Run

```
docker run -u `id -u` \
       -v $HOME/.ssh/libra.pem:/opt/app-root/src/.ssh/id_rsa:Z,ro \
       -v $HOME/.ssh/dockerconfig:/opt/app-root/src/.ssh/config:Z,ro \
       -v /tmp/aws/hosts:/tmp/inventory/hosts:Z,ro \
       -it juanvallejo/inventory-gen /bin/bash
```
