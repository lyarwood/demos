#!/bin/bash

. ../../../demo-magic/demo-magic.sh

clear

cleanup(){
    ./cluster-up/kubectl.sh delete virtualmachineinstancetype/overcommit vm/cirros dv/fedora pvc/fedora vm/fedora
    ./cluster-up/kubectl.sh delete virtualmachineclusterinstancetype -linstancetype.kubevirt.io/vendor=kubevirt.io
    ./cluster-up/kubectl.sh delete virtualmachineclusterpreference -linstancetype.kubevirt.io/vendor=kubevirt.io
}

demoDir=$(pwd)

cd /home/lyarwood/redhat/devel/src/k8s/kubevirt/kubevirt

cleanup &>/dev/null

unset TYPE_SPEED

pei "# "
pei "# --------------------------------------------------------------------------------"
pei "# Demo - KubeVirt - instancetype.kubevirt.io/v1beta1 & common-instancetypes v0.3.0"
pei "# --------------------------------------------------------------------------------"
pei "# "
pei "# Personal blog    - https://blog.yarwood.me.uk/2023/06/22/kubevirt_instancetype_update_5/"
pei "# KubeVirt blog PR - https://github.com/kubevirt/kubevirt.github.io/pull/908"
pei "# KubeVirt docs PR - https://github.com/kubevirt/user-guide/pull/687"
pei "# Demo             - https://github.com/lyarwood/demos/tree/main/kubevirt/instancetypes/6-v1beta1"
pei "# "
pei "env | grep KUBEVIRT"

sleep 5

export TYPE_SPEED=60

clear

pei "# "
pei "# instancetype.kubevirt.io/v1beta1"
pei "# "
pei "# https://blog.yarwood.me.uk/2023/06/22/kubevirt_instancetype_update_5/#instancetypekubevirtiov1beta1"
pei "# "

sleep 5

pei "# "
pei "# spec.memory.overcommitPercent by vladikr"
pei "# "
pei "# https://github.com/kubevirt/kubevirt/pull/9799"
pei "# "

pei "yq ${demoDir}/overcommit.yaml"
pei "./cluster-up/kubectl.sh apply -f ${demoDir}/overcommit.yaml"

sleep 5

pei "./cluster-up/virtctl.sh create vm \
  --instancetype virtualmachineinstancetype/overcommit \
  --volume-containerdisk name:cirros,src:registry:5000/kubevirt/cirros-container-disk-demo:devel \
  --name cirros | yq .
"

pei " ./cluster-up/virtctl.sh create vm \
  --instancetype virtualmachineinstancetype/overcommit \
  --volume-containerdisk name:cirros,src:registry:5000/kubevirt/cirros-container-disk-demo:devel \
  --name cirros | ./cluster-up/kubectl.sh apply -f -
"

sleep 5

pei "# "
pei "# We can see that the VirtualMachineInstance is exposing 128Mi of memory"
pei "# to the guest but is only requesting 114085072 or ~108Mi"
pei "# "
pei " ./cluster-up/kubectl.sh get vmi/cirros -o json | jq .spec.domain.memory,.spec.domain.resources"

sleep 5

clear

pei "# "
pei "# common-instancetypes v0.3.0"
pei "# "
pei "# https://blog.yarwood.me.uk/2023/06/22/kubevirt_instancetype_update_5/#common-instancetypes"
pei "# "

sleep 5

pei "./cluster-up/kubectl.sh apply \
  -f https://github.com/kubevirt/common-instancetypes/releases/download/v0.3.0/common-clusterinstancetypes-bundle-v0.3.0.yaml \
  -f https://github.com/kubevirt/common-instancetypes/releases/download/v0.3.0/common-clusterpreferences-bundle-v0.3.0.yaml
"
sleep 5

pei "# "
pei "# A new O instance type class has been introduced, currently only providing memory overcommit"
pei "# "
pei "./cluster-up/kubectl.sh get virtualmachineclusterinstancetypes | grep o1"

pei "# "
pei "# server and highperformance instance type classes have been deprecated ahead of removal in v0.4.0"
pei "# "
pei "./cluster-up/kubectl.sh get virtualmachineclusterinstancetypes \
    -linstancetype.kubevirt.io/deprecated=true
"

sleep 5

pei "# "
pei "# Additional labels have also been added to allow easier querying of the available resources, more to come in v0.4.0!"
pei "# "
pei "./cluster-up/kubectl.sh get virtualmachineclusterinstancetype \
    -linstancetype.kubevirt.io/hugepages=true
"

pei "./cluster-up/kubectl.sh get virtualmachineclusterinstancetype \
    -linstancetype.kubevirt.io/cpu=4
"

pei "./cluster-up/kubectl.sh get virtualmachineclusterinstancetype \
    -linstancetype.kubevirt.io/cpu=4,instancetype.kubevirt.io/hugepages=true
"

sleep 5

clear

pei "# "
pei "# virtctl image-upload --default-{instancetype,preference}"
pei "# "
pei "# https://blog.yarwood.me.uk/2023/06/22/kubevirt_instancetype_update_5/#virtctl-image-upload"
pei "# "

pei "./cluster-up/virtctl.sh image-upload dv fedora \
  --size=5Gi \
  --default-instancetype u1.medium \
  --default-preference fedora \
  --force-bind \
  --image-path=./Fedora-Cloud-Base-38-1.6.x86_64.qcow2
"

pei "./cluster-up/kubectl.sh get dv/fedora -o json | jq .metadata.labels"
pei "./cluster-up/kubectl.sh get pvc/fedora -o json | jq .metadata.labels"

sleep 5

pei "./cluster-up/virtctl.sh create vm \
  --volume-pvc=name:fedora,src:fedora \
  --infer-instancetype \
  --infer-preference \
  --name fedora | yq .
"

sleep 5

pei "./cluster-up/virtctl.sh create vm \
  --volume-pvc=name:fedora,src:fedora \
  --infer-instancetype \
  --infer-preference \
  --name fedora | ./cluster-up/kubectl.sh apply -f -
"
sleep 5

pei "./cluster-up/kubectl.sh get vms/fedora -o json | jq '.spec.instancetype,.spec.preference'"

sleep 5

clear

pei "# "
pei "# Preference resource requirements"
pei "# "
pei "# https://blog.yarwood.me.uk/2023/06/22/kubevirt_instancetype_update_5/#resource-requirements"
pei "# "

sleep 5

pei "./cluster-up/kubectl.sh get virtualmachineclusterpreference/fedora -o json | jq .spec"

pei "./cluster-up/kubectl.sh get virtualmachineclusterinstancetype/server.micro -o json | jq .spec"

sleep 5

pei "./cluster-up/virtctl.sh create vm \
  --volume-pvc=name:fedora,src:fedora \
  --instancetype server.micro \
  --infer-preference \
  --name preference-resource-requirements | ./cluster-up/kubectl.sh apply -f -
"

sleep 5

pei "yq ${demoDir}/vm-preference-resource-requirements.yaml"
pei "./cluster-up/kubectl.sh apply -f ${demoDir}/vm-preference-resource-requirements.yaml"

sleep 5

cleanup &>/dev/null

cd ${demoDir}