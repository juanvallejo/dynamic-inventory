Dynamic Inventory Generation
============================

Docker image for creating a container capable of
connecting to an OpenShift master and dynamically
creating an inventory file from its environment.

### Build

`docker build --rm -t juanvallejo/inventory-gen .`

### Run

The command below will:

1. Connect to the host using the bind-mounted `id_rsa` file.
2. Generate an inventory file based on the current configuration and environment of the existing OpenShift deployment on the remote host
3. run the specified [openshift-ansible](https://github.com/openshift/openshift-ansible) `health.yml` playbook using the generated inventory file from the previous step

```
docker run -u `id -u` \
       -v $HOME/.ssh/id_rsa:/opt/app-root/src/.ssh/id_rsa:Z,ro \
       -v /tmp/ssh/config:/opt/app-root/src/.ssh/config:Z,ro \
       -v /tmp/origin/master/admin.kubeconfig:/opt/app-root/src/.kube/config:Z \
       -v /tmp/aws/master-config.yaml:/opt/app-root/src/master-config.yaml:Z \
       -e PLAYBOOK=playbooks/byo/openshift-checks/health.yml \
       juanvallejo/inventory-gen
```

If a `PLAYBOOK` environment variable is not supplied, the container will simply perform steps `1` and `2` from above, and output the contents of the generated inventory file to standard output.

```
$ docker run -u `id -u` \
       -v $HOME/.ssh/id_rsa:/opt/app-root/src/.ssh/id_rsa:Z,ro \
       -v /tmp/ssh/config:/opt/app-root/src/.ssh/config:Z,ro \
       -v /tmp/origin/master/admin.kubeconfig:/opt/app-root/src/.kube/config:Z \
       -v /tmp/aws/master-config.yaml:/opt/app-root/src/master-config.yaml:Z \
       juanvallejo/inventory-gen > myinventory

$ cat myinventory
localhost ansible_python_interpreter=/usr/bin/python

[OSEv3:children]
masters
nodes
etcd

[OSEv3:vars]
...
```

### Debug

To debug the `run` script, run the above script interactively
and manually execute `/usr/local/bin/run`:

```
...
docker run -u `id -u` \
       -v ...
       ...
       -it juanvallejo/inventory-gen /bin/bash

---

bash-4.2$ ls
master-config.yaml
bash-4.2$ /usr/local/bin/generate
bash-4.2$ ls
generated_hosts  master-config.yaml
bash-4.2$ less generated_hosts
...
```
