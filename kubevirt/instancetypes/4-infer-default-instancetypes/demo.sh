#!/bin/bash
#
# This demo was written against a development env of KubeVirt:
# https://github.com/kubevirt/kubevirt/pull/8480
# $ env | grep KUBEVIRT
# KUBEVIRT_PROVIDER=k8s-1.24
# KUBEVIRT_MEMORY=16384

. ../../../demo-magic/demo-magic.sh

clear

cleanup(){
    ./cluster-up/kubectl.sh delete pvc/cirros
    ./cluster-up/kubectl.sh delete vms/cirros
    ./cluster-up/kubectl.sh delete dvs/cirros-dv
}

demoDir=$(pwd)

cd /home/lyarwood/redhat/devel/src/k8s/kubevirt/kubevirt

cleanup &>/dev/null

export TYPE_SPEED=60

pei "# Agenda"
pei "# 1. Environment setup"
pei "# 2. Instance type and preference inference directly from an existing PVC"
pei "# 3. Instance type and preference inference indirectly through DataVolume and PVC"
pei "# 4. Instance type and preference inference indirectly through DataVolume, DataVolumeTemplate and PVC"
pei "# 5. Instance type and preference inference indirectly through DataVolume, DataVolumeTemplate, DataSource and PVC"

sleep 5

clear

pei "# 1. Environment setup"

pei "gh pr checkout 8480"

pei "env | grep KUBEVIRT"

pei "./cluster-up/virtctl.sh image-upload pvc cirros --size=1Gi --image-path=./cirros-0.5.2-x86_64-disk.img"

# FIXME - switch to kubevirt/common-instancetypes once PR #1 lands

pei "./cluster-up/kubectl.sh kustomize https://github.com/lyarwood/common-instancetypes?ref=micro | ./cluster-up/kubectl.sh apply -f -"

pei "./cluster-up/kubectl.sh annotate pvc/cirros instancetype.kubevirt.io/defaultInstancetype=server.micro instancetype.kubevirt.io/defaultPreference=cirros"

pei "# 2. Instance type and preference inference directly from an existing PVC"

pei "yq . ${demoDir}/vm-demo-pvc.yaml"

pei "./cluster-up/kubectl.sh apply -f ${demoDir}/vm-demo-pvc.yaml"

pei "./cluster-up/kubectl.sh get vms/cirros -o json | jq '.spec.instancetype, .spec.preference'"

sleep 3

./cluster-up/kubectl.sh delete vms/cirros

pei "# 3. Instance type and preference inference indirectly through DataVolume and PVC"

pei "yq . ${demoDir}/dv-demo.yaml"

pei "yq . ${demoDir}/vm-demo-dv.yaml"

pei "./cluster-up/kubectl.sh apply -f ${demoDir}/dv-demo.yaml -f ${demoDir}/vm-demo-dv.yaml"

pei "./cluster-up/kubectl.sh get vms/cirros -o json | jq '.spec.instancetype, .spec.preference'"

sleep 3

./cluster-up/kubectl.sh delete vms/cirros

pei "# 4. Instance type and preference inference indirectly through DataVolume, DataVolumeTemplate and PVC"

pei "yq . ${demoDir}/vm-demo-dvt.yaml"

pei "./cluster-up/kubectl.sh apply -f ${demoDir}/vm-demo-dvt.yaml"

pei "./cluster-up/kubectl.sh get vms/cirros -o json | jq '.spec.instancetype, .spec.preference'"

sleep 3

./cluster-up/kubectl.sh delete vms/cirros

pei "# 5. Instance type and preference inference indirectly through DataVolume, DataVolumeTemplate, DataSource and PVC"

pei "yq . ${demoDir}/vm-demo-ds.yaml"

pei "yq . ${demoDir}/vm-demo-dvt-ds.yaml"

pei "./cluster-up/kubectl.sh apply -f ${demoDir}/vm-demo-ds.yaml -f ${demoDir}/vm-demo-dvt-ds.yaml"

pei "./cluster-up/kubectl.sh get vms/cirros -o json | jq '.spec.instancetype, .spec.preference'"

sleep 3