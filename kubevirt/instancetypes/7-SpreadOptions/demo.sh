#!/bin/bash

. ../../../demo-magic/demo-magic.sh

clear

cleanup(){
    ./cluster-up/kubectl.sh delete virtualmachinepreference/default-spread virtualmachinepreference/sct-spread virtualmachinepreference/sct-ratio-spread virtualmachineinstancetype/spread vm/spread
}

demoDir=$(pwd)

cd /home/lyarwood/redhat/devel/src/k8s/kubevirt/kubevirt

cleanup &>/dev/null

unset TYPE_SPEED

pei "# "
pei "# -------------------------------------"
pei "# Demo - KubeVirt - PreferSpreadOptions"
pei "# -------------------------------------"
pei "# "
pei "env | grep KUBEVIRT"

sleep 5

export TYPE_SPEED=60

clear

pei "yq ${demoDir}/spread.yaml"
pei "yq ${demoDir}/default-spread.yaml"

./cluster-up/kubectl.sh apply -f ${demoDir}/spread.yaml &>/dev/null
./cluster-up/kubectl.sh apply -f ${demoDir}/default-spread.yaml &>/dev/null

sleep 5

pei "./cluster-up/virtctl.sh create vm \
--instancetype virtualmachineinstancetype/spread \
--preference virtualmachinepreference/default-spread \
--volume-containerdisk name:cirros,src:registry:5000/kubevirt/cirros-container-disk-demo:devel \
--name spread | ./cluster-up/kubectl.sh apply -f -"

./cluster-up/kubectl.sh wait --for=condition=Ready vms/spread &>/dev/null

pei "./cluster-up/kubectl.sh get vmi/spread -o json | jq .spec.domain.cpu"

./cluster-up/kubectl.sh delete vm/spread &>/dev/null

pei "yq ${demoDir}/sct-spread.yaml"

./cluster-up/kubectl.sh apply -f ${demoDir}/sct-spread.yaml &>/dev/null

pei "./cluster-up/virtctl.sh create vm \
--instancetype virtualmachineinstancetype/spread \
--preference virtualmachinepreference/sct-spread \
--volume-containerdisk name:cirros,src:registry:5000/kubevirt/cirros-container-disk-demo:devel \
--name spread | ./cluster-up/kubectl.sh apply -f -"

./cluster-up/kubectl.sh wait --for=condition=Ready vms/spread &>/dev/null

pei "./cluster-up/kubectl.sh get vmi/spread -o json | jq .spec.domain.cpu"

./cluster-up/kubectl.sh delete vm/spread &>/dev/null

pei "yq ${demoDir}/sct-ratio-spread.yaml"

./cluster-up/kubectl.sh apply -f ${demoDir}/sct-ratio-spread.yaml &>/dev/null

pei "./cluster-up/virtctl.sh create vm \
--instancetype virtualmachineinstancetype/spread \
--preference virtualmachinepreference/sct-ratio-spread \
--volume-containerdisk name:cirros,src:registry:5000/kubevirt/cirros-container-disk-demo:devel \
--name spread | ./cluster-up/kubectl.sh apply -f -"

./cluster-up/kubectl.sh wait --for=condition=Ready vms/spread &>/dev/null

pei "./cluster-up/kubectl.sh get vmi/spread -o json | jq .spec.domain.cpu"

./cluster-up/kubectl.sh delete vm/spread &>/dev/null

pei "yq ${demoDir}/ct-spread.yaml"

./cluster-up/kubectl.sh apply -f ${demoDir}/ct-spread.yaml &>/dev/null

pei "./cluster-up/virtctl.sh create vm \
--instancetype virtualmachineinstancetype/spread \
--preference virtualmachinepreference/ct-spread \
--volume-containerdisk name:cirros,src:registry:5000/kubevirt/cirros-container-disk-demo:devel \
--name spread | ./cluster-up/kubectl.sh apply -f -"

./cluster-up/kubectl.sh wait --for=condition=Ready vms/spread &>/dev/null

pei "./cluster-up/kubectl.sh get vmi/spread -o json | jq .spec.domain.cpu"

pei "yq ${demoDir}/ct-spread-bad-ratio.yaml"

pei "./cluster-up/kubectl.sh apply -f ${demoDir}/ct-spread-bad-ratio.yaml"